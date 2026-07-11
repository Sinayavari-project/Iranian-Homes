import Foundation
import SofrinoCore

/// The investor demo `AuthRepository` — BRD §1: "an investor-ready demo
/// environment that always works perfectly using local seeded data."
///
/// No networking, no Keychain dependency on Supabase reachability, no way
/// for a flaky venue WiFi to interrupt a pitch. Every call succeeds after a
/// short, realistic delay so the UI's loading states are still visible and
/// demoable — the point is reliability, not instant response.
public actor DemoAuthRepository: AuthRepository {
    private let cache: OfflineCaching
    private let cacheKey = "demo_user"
    private let artificialLatency: Duration

    public init(cache: OfflineCaching, artificialLatency: Duration = .milliseconds(600)) {
        self.cache = cache
        self.artificialLatency = artificialLatency
    }

    public func requestOTP(phoneNumber: String) async throws {
        guard UAEPhoneNumber(rawInput: phoneNumber) != nil else {
            throw AuthError.invalidPhoneNumber
        }
        try await Task.sleep(for: artificialLatency)
    }

    public func verifyOTP(phoneNumber: String, code: String) async throws -> AuthSession {
        guard let phone = UAEPhoneNumber(rawInput: phoneNumber) else {
            throw AuthError.invalidPhoneNumber
        }
        try await Task.sleep(for: artificialLatency)

        // The demo accepts a fixed code so pitch rehearsals are repeatable.
        guard code == "111111" || code.count == 6 else {
            throw AuthError.invalidOTP
        }

        let existing = cache.load(AuthUser.self, forKey: cacheKey)
        let user = existing ?? AuthUser(
            id: "demo-user-\(phone.e164)",
            phoneNumber: phone.e164,
            displayName: "Chef Khalid",
            createdAt: Date()
        )
        try? cache.save(user, forKey: cacheKey)

        return AuthSession(
            user: user,
            accessToken: "demo-access-token",
            refreshToken: "demo-refresh-token",
            expiresAt: Date().addingTimeInterval(60 * 60 * 24 * 30)
        )
    }

    public func selectRole(_ role: UserRole, for userID: String) async throws -> AuthUser {
        try await Task.sleep(for: artificialLatency)
        var user = cache.load(AuthUser.self, forKey: cacheKey) ?? AuthUser(id: userID, phoneNumber: "+971501234567")
        user.role = role
        try? cache.save(user, forKey: cacheKey)
        return user
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
        try await Task.sleep(for: artificialLatency)

        var user = cache.load(AuthUser.self, forKey: cacheKey) ?? AuthUser(id: userID, phoneNumber: "+971501234567")
        user.tradeLicenseNumber = number
        user.tradeLicenseExpiresAt = expiresAt
        user.kycStatus = .verified // Instant approval in demo mode — no ops queue to wait on.
        try? cache.save(user, forKey: cacheKey)
        return user
    }

    public func restoreSession() async -> AuthSession? {
        guard let user = cache.load(AuthUser.self, forKey: cacheKey) else { return nil }
        return AuthSession(
            user: user,
            accessToken: "demo-access-token",
            refreshToken: "demo-refresh-token",
            expiresAt: Date().addingTimeInterval(60 * 60 * 24 * 30)
        )
    }

    public func signOut() async throws {
        cache.remove(forKey: cacheKey)
    }
}
