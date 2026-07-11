import XCTest
@testable import SofrinoAuthentication

@MainActor
final class OfflineQueuingAuthRepositoryTests: XCTestCase {
    func testTradeLicenseSubmitsDirectlyWhenOnline() async throws {
        let inner = MockAuthRepository()
        let expectedUser = AuthUser(id: "user-1", phoneNumber: "", kycStatus: .pending)
        inner.submitTradeLicenseResult = .success(expectedUser)

        let reachability = MockReachability()
        reachability.isConnected = true

        let sut = OfflineQueuingAuthRepository(inner: inner, cache: InMemoryOfflineCache(), reachability: reachability)

        let result = try await sut.submitTradeLicense(
            number: "123456",
            expiresAt: Date().addingTimeInterval(3600 * 24 * 365),
            documentData: Data([0x01]),
            for: "user-1"
        )

        XCTAssertEqual(inner.submitTradeLicenseCallCount, 1)
        XCTAssertEqual(result, expectedUser)
    }

    func testTradeLicenseQueuesWhenOfflineAndReturnsOptimisticResult() async throws {
        let inner = MockAuthRepository()
        let reachability = MockReachability()
        reachability.isConnected = false

        let sut = OfflineQueuingAuthRepository(inner: inner, cache: InMemoryOfflineCache(), reachability: reachability)

        let expiresAt = Date().addingTimeInterval(3600 * 24 * 365)
        let result = try await sut.submitTradeLicense(
            number: "123456",
            expiresAt: expiresAt,
            documentData: Data([0x01]),
            for: "user-1"
        )

        // The inner repository must not be touched while offline — the
        // whole point of queuing is to avoid a doomed network call.
        XCTAssertEqual(inner.submitTradeLicenseCallCount, 0)
        XCTAssertEqual(result.kycStatus, .pending)
        XCTAssertEqual(result.tradeLicenseNumber, "123456")
    }

    func testQueuedOperationDrainsAutomaticallyWhenConnectivityReturns() async throws {
        let inner = MockAuthRepository()
        let expectedUser = AuthUser(id: "user-1", phoneNumber: "", kycStatus: .verified)
        inner.submitTradeLicenseResult = .success(expectedUser)

        let reachability = MockReachability()
        reachability.isConnected = false

        let sut = OfflineQueuingAuthRepository(inner: inner, cache: InMemoryOfflineCache(), reachability: reachability)

        _ = try await sut.submitTradeLicense(
            number: "654321",
            expiresAt: Date().addingTimeInterval(3600 * 24 * 365),
            documentData: Data([0x02]),
            for: "user-1"
        )
        XCTAssertEqual(inner.submitTradeLicenseCallCount, 0)

        reachability.simulateChange(to: true)
        // `drain()` runs in a detached Task off the connectivity callback —
        // give it a beat to complete.
        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertEqual(inner.submitTradeLicenseCallCount, 1)
    }

    func testOtherMethodsPassThroughUnchanged() async throws {
        let inner = MockAuthRepository()
        inner.requestOTPError = nil
        let reachability = MockReachability()

        let sut = OfflineQueuingAuthRepository(inner: inner, cache: InMemoryOfflineCache(), reachability: reachability)

        try await sut.requestOTP(phoneNumber: "+971501234567")
        XCTAssertEqual(inner.requestOTPCallCount, 1)
    }
}
