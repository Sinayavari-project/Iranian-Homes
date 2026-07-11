import Foundation
import Observation

/// Reads/writes the persisted session to the Keychain and exposes it to
/// `HTTPClient` for request signing. This protocol is intentionally
/// `async`-only (rather than a synchronous property) so callers never
/// assume Keychain access is free — on some devices, first access after
/// boot before the user unlocks can briefly stall.
public protocol SessionStoring: Sendable {
    func currentSession() async -> PersistedSession?
    func save(_ session: PersistedSession) async throws
    func clear() async throws
}

/// The `@Observable` façade used by SwiftUI views to react to sign-in /
/// sign-out without polling — `RootView` observes `isAuthenticated` to
/// decide between the auth flow and the main app shell.
@MainActor
@Observable
public final class SessionStore: SessionStoring {
    public private(set) var session: PersistedSession?

    private let keychain: KeychainStoring
    private let keychainKey = "sofrino.session"
    private let logger = SofrinoLogger(category: "session")

    public var isAuthenticated: Bool {
        guard let session else { return false }
        return !session.isExpired
    }

    public init(keychain: KeychainStoring) {
        self.keychain = keychain
        self.session = Self.loadFromKeychain(keychain)
    }

    public func currentSession() async -> PersistedSession? {
        session
    }

    public func save(_ session: PersistedSession) async throws {
        let data = try JSONEncoder.sofrinoDefault.encode(session)
        try keychain.save(data, forKey: keychainKey)
        self.session = session
        logger.info("Session saved for user \(session.userID)")
    }

    public func clear() async throws {
        try keychain.delete(forKey: keychainKey)
        session = nil
        logger.info("Session cleared")
    }

    private static func loadFromKeychain(_ keychain: KeychainStoring) -> PersistedSession? {
        guard let data = try? keychain.read(forKey: "sofrino.session") else { return nil }
        return try? JSONDecoder.sofrinoDefault.decode(PersistedSession.self, from: data)
    }
}
