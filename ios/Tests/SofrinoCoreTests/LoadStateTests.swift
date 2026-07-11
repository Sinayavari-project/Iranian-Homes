import XCTest
@testable import SofrinoCore

final class LoadStateTests: XCTestCase {
    func testValueExtractsLoadedPayload() {
        let state: LoadState<[Int]> = .loaded([1, 2, 3])
        XCTAssertEqual(state.value, [1, 2, 3])
    }

    func testValueIsNilForOtherStates() {
        XCTAssertNil(LoadState<Int>.idle.value)
        XCTAssertNil(LoadState<Int>.loading.value)
        XCTAssertNil(LoadState<Int>.failed("error").value)
    }

    func testIsLoadingOnlyTrueForLoadingCase() {
        XCTAssertTrue(LoadState<Int>.loading.isLoading)
        XCTAssertFalse(LoadState<Int>.idle.isLoading)
        XCTAssertFalse(LoadState<Int>.loaded(1).isLoading)
    }

    func testErrorMessageExtractsFailureReason() {
        XCTAssertEqual(LoadState<Int>.failed("network down").errorMessage, "network down")
        XCTAssertNil(LoadState<Int>.loaded(1).errorMessage)
    }

    func testHasResolvedDistinguishesAttemptedFromNotYetTried() {
        XCTAssertFalse(LoadState<Int>.idle.hasResolved)
        XCTAssertFalse(LoadState<Int>.loading.hasResolved)
        XCTAssertTrue(LoadState<Int>.loaded(1).hasResolved)
        XCTAssertTrue(LoadState<Int>.failed("x").hasResolved)
    }
}
