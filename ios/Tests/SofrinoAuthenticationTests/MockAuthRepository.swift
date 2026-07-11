import Foundation
@testable import SofrinoAuthentication
import SofrinoCore

/// A fully scriptable `AuthRepository` test double — no networking, no
/// Keychain, no timing. Every method's behavior is controlled by the
/// properties below, set per-test before exercising a view model.
final class MockAuthRepository: AuthRepository, @unchecked Sendable {
    var requestOTPError: Error?
    var requestOTPCallCount = 0
    var lastRequestedPhoneNumber: String?

    var verifyOTPResult: Result<AuthSession, Error> = .failure(AuthError.invalidOTP)
    var verifyOTPCallCount = 0

    var selectRoleResult: Result<AuthUser, Error> = .failure(AuthError.invalidOTP)

    var submitTradeLicenseResult: Result<AuthUser, Error> = .failure(AuthError.invalidOTP)
    var submitTradeLicenseCallCount = 0

    var restoreSessionResult: AuthSession?

    func requestOTP(phoneNumber: String) async throws {
        requestOTPCallCount += 1
        lastRequestedPhoneNumber = phoneNumber
        if let requestOTPError { throw requestOTPError }
    }

    func verifyOTP(phoneNumber: String, code: String) async throws -> AuthSession {
        verifyOTPCallCount += 1
        switch verifyOTPResult {
        case .success(let session): return session
        case .failure(let error): throw error
        }
    }

    func selectRole(_ role: UserRole, for userID: String) async throws -> AuthUser {
        switch selectRoleResult {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }

    func submitTradeLicense(number: String, expiresAt: Date, documentData: Data, for userID: String) async throws -> AuthUser {
        submitTradeLicenseCallCount += 1
        switch submitTradeLicenseResult {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }

    func restoreSession() async -> AuthSession? {
        restoreSessionResult
    }

    func signOut() async throws {}
}

final class InMemoryOfflineCache: OfflineCaching, @unchecked Sendable {
    private var storage: [String: Data] = [:]

    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        storage[key] = try JSONEncoder.sofrinoDefault.encode(value)
    }

    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = storage[key] else { return nil }
        return try? JSONDecoder.sofrinoDefault.decode(T.self, from: data)
    }

    func remove(forKey key: String) { storage.removeValue(forKey: key) }
    func clear() { storage.removeAll() }
}

@MainActor
final class MockReachability: ReachabilityMonitoring {
    var isConnected: Bool = true
    private var handlers: [(Bool) -> Void] = []

    func onConnectivityChange(_ handler: @escaping (Bool) -> Void) {
        handlers.append(handler)
    }

    func simulateChange(to isConnected: Bool) {
        self.isConnected = isConnected
        handlers.forEach { $0(isConnected) }
    }
}
