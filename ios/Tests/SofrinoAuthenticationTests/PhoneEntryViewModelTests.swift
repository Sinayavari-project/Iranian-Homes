import XCTest
@testable import SofrinoAuthentication

@MainActor
final class PhoneEntryViewModelTests: XCTestCase {
    func testInvalidNumberDisablesSubmit() {
        let viewModel = PhoneEntryViewModel(repository: MockAuthRepository())
        viewModel.rawInput = "123"
        XCTAssertFalse(viewModel.canSubmit)
    }

    func testValidNumberEnablesSubmit() {
        let viewModel = PhoneEntryViewModel(repository: MockAuthRepository())
        viewModel.rawInput = "0501234567"
        XCTAssertTrue(viewModel.canSubmit)
    }

    func testOfflineDisablesSubmitEvenWithValidNumber() {
        let viewModel = PhoneEntryViewModel(repository: MockAuthRepository())
        viewModel.rawInput = "0501234567"
        viewModel.isOffline = true
        XCTAssertFalse(viewModel.canSubmit)
    }

    func testSuccessfulSubmitInvokesCallbackWithE164Number() async {
        let repository = MockAuthRepository()
        let viewModel = PhoneEntryViewModel(repository: repository)
        viewModel.rawInput = "0501234567"

        var receivedPhoneNumber: String?
        viewModel.onOTPRequested = { receivedPhoneNumber = $0 }

        await viewModel.submit()

        XCTAssertEqual(repository.requestOTPCallCount, 1)
        XCTAssertEqual(receivedPhoneNumber, "+971501234567")
        XCTAssertEqual(viewModel.submitState, .idle)
    }

    func testFailedSubmitSurfacesErrorMessage() async {
        let repository = MockAuthRepository()
        repository.requestOTPError = AuthError.network(.offline)
        let viewModel = PhoneEntryViewModel(repository: repository)
        viewModel.rawInput = "0501234567"

        var callbackInvoked = false
        viewModel.onOTPRequested = { _ in callbackInvoked = true }

        await viewModel.submit()

        XCTAssertFalse(callbackInvoked)
        guard case .failed(let message) = viewModel.submitState else {
            return XCTFail("Expected .failed state")
        }
        XCTAssertFalse(message.isEmpty)
    }

    func testEditingInputClearsFailedState() async {
        let repository = MockAuthRepository()
        repository.requestOTPError = AuthError.invalidPhoneNumber
        let viewModel = PhoneEntryViewModel(repository: repository)
        viewModel.rawInput = "0501234567"
        await viewModel.submit()

        viewModel.rawInput = "0501234568"
        XCTAssertEqual(viewModel.submitState, .idle)
    }
}
