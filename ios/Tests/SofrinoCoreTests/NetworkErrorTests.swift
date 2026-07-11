import XCTest
@testable import SofrinoCore

final class NetworkErrorTests: XCTestCase {
    func testOfflineIsRetryable() {
        XCTAssertTrue(NetworkError.offline.isRetryable)
    }

    func testUnauthorizedIsNotRetryable() {
        XCTAssertFalse(NetworkError.unauthorized.isRetryable)
    }

    func testDecodingErrorIsNotRetryable() {
        XCTAssertFalse(NetworkError.decoding("bad shape").isRetryable)
    }

    func testServerErrorMessageFallsBackWhenNilMessage() {
        let error = NetworkError.server(statusCode: 500, message: nil)
        XCTAssertFalse(error.userFacingMessage.isEmpty)
    }

    func testServerErrorPrefersProvidedMessage() {
        let error = NetworkError.server(statusCode: 422, message: "Trade license already in use")
        XCTAssertEqual(error.userFacingMessage, "Trade license already in use")
    }

    func testCancelledProducesEmptyMessage() {
        // Cancelled requests (e.g. a superseded search-as-you-type call)
        // should never surface an error banner to the user.
        XCTAssertEqual(NetworkError.cancelled.userFacingMessage, "")
    }
}
