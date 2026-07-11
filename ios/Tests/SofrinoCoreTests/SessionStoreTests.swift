import XCTest
@testable import SofrinoCore

private final class InMemoryKeychainStore: KeychainStoring, @unchecked Sendable {
    private var storage: [String: Data] = [:]
    func save(_ data: Data, forKey key: String) throws { storage[key] = data }
    func read(forKey key: String) throws -> Data? { storage[key] }
    func delete(forKey key: String) throws { storage.removeValue(forKey: key) }
}

@MainActor
final class SessionStoreTests: XCTestCase {
    func testStartsUnauthenticatedWithEmptyKeychain() {
        let store = SessionStore(keychain: InMemoryKeychainStore())
        XCTAssertFalse(store.isAuthenticated)
        XCTAssertNil(store.session)
    }

    func testSaveMakesStoreAuthenticated() async throws {
        let store = SessionStore(keychain: InMemoryKeychainStore())
        let session = PersistedSession(
            userID: "user-1",
            accessToken: "token",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(3600)
        )
        try await store.save(session)
        XCTAssertTrue(store.isAuthenticated)
    }

    func testExpiredSessionIsNotAuthenticated() async throws {
        let store = SessionStore(keychain: InMemoryKeychainStore())
        let expiredSession = PersistedSession(
            userID: "user-1",
            accessToken: "token",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(-60)
        )
        try await store.save(expiredSession)
        XCTAssertFalse(store.isAuthenticated)
    }

    func testClearRemovesSession() async throws {
        let keychain = InMemoryKeychainStore()
        let store = SessionStore(keychain: keychain)
        try await store.save(
            PersistedSession(userID: "user-1", accessToken: "t", refreshToken: "r", expiresAt: Date().addingTimeInterval(3600))
        )
        try await store.clear()
        XCTAssertFalse(store.isAuthenticated)
        XCTAssertNil(store.session)
    }

    func testSessionPersistsAcrossStoreInstances() async throws {
        let keychain = InMemoryKeychainStore()
        let firstStore = SessionStore(keychain: keychain)
        try await firstStore.save(
            PersistedSession(userID: "user-1", accessToken: "t", refreshToken: "r", expiresAt: Date().addingTimeInterval(3600))
        )

        let secondStore = SessionStore(keychain: keychain)
        XCTAssertTrue(secondStore.isAuthenticated)
        XCTAssertEqual(secondStore.session?.userID, "user-1")
    }
}
