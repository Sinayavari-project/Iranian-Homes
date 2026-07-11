import Foundation
import SofrinoCore

/// Production `AuthRepository`, backed directly by Supabase's Auth and
/// PostgREST REST APIs over `HTTPClientProtocol`. Every method maps
/// transport failures into `AuthError` at this boundary — nothing above
/// this layer ever sees a raw `NetworkError` or a Supabase wire type.
public final class SupabaseAuthRepository: AuthRepository {
    private let httpClient: HTTPClientProtocol
    private let sessionStore: SessionStoring
    private let logger = SofrinoLogger(category: "auth-repository")

    public init(httpClient: HTTPClientProtocol, sessionStore: SessionStoring) {
        self.httpClient = httpClient
        self.sessionStore = sessionStore
    }

    public func requestOTP(phoneNumber: String) async throws {
        guard let phone = UAEPhoneNumber(rawInput: phoneNumber) else {
            throw AuthError.invalidPhoneNumber
        }

        let body = OTPRequestBody(phone: phone.e164, createUser: true)

        do {
            let data = try Endpoint.jsonBody(body)
            let endpoint = Endpoint(
                path: "auth/v1/otp",
                method: .post,
                body: data,
                requiresAuth: false
            )
            try await httpClient.send(endpoint)
        } catch let error as NetworkError {
            throw AuthError.network(error)
        }
    }

    public func verifyOTP(phoneNumber: String, code: String) async throws -> AuthSession {
        guard let phone = UAEPhoneNumber(rawInput: phoneNumber) else {
            throw AuthError.invalidPhoneNumber
        }
        guard code.count == 6, code.allSatisfy(\.isNumber) else {
            throw AuthError.invalidOTP
        }

        let body = OTPVerifyRequestBody(phone: phone.e164, token: code)

        let authResponse: SupabaseAuthResponseDTO
        do {
            let data = try Endpoint.jsonBody(body)
            let endpoint = Endpoint(
                path: "auth/v1/verify",
                method: .post,
                body: data,
                requiresAuth: false
            )
            authResponse = try await httpClient.send(endpoint, as: SupabaseAuthResponseDTO.self)
        } catch NetworkError.server(400, _), NetworkError.server(401, _) {
            throw AuthError.invalidOTP
        } catch let error as NetworkError {
            throw AuthError.network(error)
        }

        let expiresAt = Date().addingTimeInterval(TimeInterval(authResponse.expiresIn))

        // Persist immediately so the profile fetch below is authenticated.
        try await sessionStore.save(
            PersistedSession(
                userID: authResponse.user.id,
                accessToken: authResponse.accessToken,
                refreshToken: authResponse.refreshToken,
                expiresAt: expiresAt
            )
        )

        let profile = try await fetchOrCreateProfile(
            userID: authResponse.user.id,
            createdAt: authResponse.user.createdAt
        )

        let user = AuthUser(
            profile: profile,
            phoneNumber: authResponse.user.phone ?? phone.e164,
            createdAt: authResponse.user.createdAt
        )

        return AuthSession(
            user: user,
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
            expiresAt: expiresAt
        )
    }

    public func selectRole(_ role: UserRole, for userID: String) async throws -> AuthUser {
        let body = ProfileUpsertBody(id: userID, role: role.rawValue, kycStatus: nil, tradeLicenseNumber: nil, tradeLicenseExpiresAt: nil)
        return try await upsertProfile(body)
    }

    public func submitTradeLicense(
        number: String,
        expiresAt: Date,
        documentData: Data,
        for userID: String
    ) async throws -> AuthUser {
        guard number.count == 6, number.allSatisfy(\.isNumber) else {
            throw AuthError.tradeLicenseInvalid(reason: "Trade license number must be 6 digits")
        }
        guard expiresAt > Date() else {
            throw AuthError.tradeLicenseInvalid(reason: "This trade license has already expired")
        }

        do {
            let uploadEndpoint = Endpoint(
                path: "storage/v1/object/trade-licenses/\(userID)/license.jpg",
                method: .post,
                headers: ["Content-Type": "image/jpeg", "x-upsert": "true"],
                body: documentData
            )
            try await httpClient.send(uploadEndpoint)
        } catch let error as NetworkError {
            throw AuthError.network(error)
        }

        let body = ProfileUpsertBody(
            id: userID,
            role: nil,
            kycStatus: KYCStatus.pending.rawValue,
            tradeLicenseNumber: number,
            tradeLicenseExpiresAt: expiresAt
        )
        return try await upsertProfile(body)
    }

    public func restoreSession() async -> AuthSession? {
        guard let persisted = await sessionStore.currentSession(), !persisted.isExpired else {
            return nil
        }
        guard let profile = try? await fetchProfile(userID: persisted.userID) else {
            return nil
        }
        let user = AuthUser(profile: profile, phoneNumber: "", createdAt: profile.createdAt)
        return AuthSession(
            user: user,
            accessToken: persisted.accessToken,
            refreshToken: persisted.refreshToken,
            expiresAt: persisted.expiresAt
        )
    }

    public func signOut() async throws {
        do {
            try await httpClient.send(Endpoint(path: "auth/v1/logout", method: .post))
        } catch {
            logger.error("Remote sign-out failed, clearing local session anyway: \(error)")
        }
        try await sessionStore.clear()
    }

    // MARK: - Profile helpers

    private func fetchOrCreateProfile(userID: String, createdAt: Date) async throws -> ProfileDTO {
        if let existing = try? await fetchProfile(userID: userID) {
            return existing
        }
        let body = ProfileUpsertBody(id: userID, role: nil, kycStatus: KYCStatus.notSubmitted.rawValue, tradeLicenseNumber: nil, tradeLicenseExpiresAt: nil)
        return try await upsertProfileDTO(body)
    }

    private func fetchProfile(userID: String) async throws -> ProfileDTO {
        let endpoint = Endpoint(
            path: "rest/v1/profiles",
            queryItems: [
                URLQueryItem(name: "id", value: "eq.\(userID)"),
                URLQueryItem(name: "select", value: "*"),
                URLQueryItem(name: "limit", value: "1")
            ],
            headers: ["Accept": "application/vnd.pgrst.object+json"]
        )
        do {
            return try await httpClient.send(endpoint, as: ProfileDTO.self)
        } catch let error as NetworkError {
            throw AuthError.network(error)
        }
    }

    private func upsertProfile(_ body: ProfileUpsertBody) async throws -> AuthUser {
        let profile = try await upsertProfileDTO(body)
        return AuthUser(profile: profile, phoneNumber: "", createdAt: profile.createdAt)
    }

    private func upsertProfileDTO(_ body: ProfileUpsertBody) async throws -> ProfileDTO {
        do {
            let data = try Endpoint.jsonBody(body)
            let endpoint = Endpoint(
                path: "rest/v1/profiles",
                method: .post,
                headers: [
                    "Prefer": "resolution=merge-duplicates,return=representation",
                    "Accept": "application/vnd.pgrst.object+json"
                ],
                body: data
            )
            return try await httpClient.send(endpoint, as: ProfileDTO.self)
        } catch let error as NetworkError {
            throw AuthError.network(error)
        }
    }
}
