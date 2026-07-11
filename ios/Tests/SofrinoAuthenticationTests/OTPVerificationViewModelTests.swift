import XCTest
@testable import SofrinoAuthentication

@MainActor
final class OTPVerificationViewModelTests: XCTestCase {
    private func makeSession(role: UserRole? = nil, kycStatus: KYCStatus = .notSubmitted) -> AuthSession {
        AuthSession(
            user: AuthUser(id: "user-1", phoneNumber: "+971501234567", role: role, kycStatus: kycStatus),
            accessToken: "token",
            refreshToken: "refresh",
            expiresAt: Date().addingTimeInterval(3600)
        )
    }

    func testAutoSubmitsWhenSixthDigitEntered() async {
        let repository = MockAuthRepository()
        repository.verifyOTPResult = .success(makeSession())
        let viewModel = OTPVerificationViewModel(phoneNumber: "+971501234567", repository: repository)

        var receivedSession: AuthSession?
        viewModel.onVerified = { receivedSession = $0 }

        viewModel.code = "123456"
        // The auto-submit is fired from `didSet`, which kicks off a
        // detached Task — give the run loop a beat to complete it.
        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertEqual(repository.verifyOTPCallCount, 1)
        XCTAssertNotNil(receivedSession)
    }

    func testDoesNotSubmitBeforeSixDigits() async {
        let repository = MockAuthRepository()
        let viewModel = OTPVerificationViewModel(phoneNumber: "+971501234567", repository: repository)

        viewModel.code = "123"
        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertEqual(repository.verifyOTPCallCount, 0)
    }

    func testFailedVerificationClearsCodeAndSetsError() async {
        let repository = MockAuthRepository()
        repository.verifyOTPResult = .failure(AuthError.invalidOTP)
        let viewModel = OTPVerificationViewModel(phoneNumber: "+971501234567", repository: repository)

        await viewModel.verify() // code is empty, but we exercise verify() directly for determinism
        viewModel.code = "999999"
        await viewModel.verify()

        XCTAssertEqual(viewModel.code, "")
        guard case .failed = viewModel.submitState else {
            return XCTFail("Expected .failed state after invalid OTP")
        }
    }

    func testResendCooldownBlocksImmediateResend() {
        let viewModel = OTPVerificationViewModel(phoneNumber: "+971501234567", repository: MockAuthRepository())
        XCTAssertEqual(viewModel.resendCooldownSeconds, 60)
        XCTAssertFalse(viewModel.canResend)
    }

    func testMaskedPhoneNumberFormatsForDisplay() {
        let viewModel = OTPVerificationViewModel(phoneNumber: "+971501234567", repository: MockAuthRepository())
        XCTAssertEqual(viewModel.maskedPhoneNumber, "+971 50 123 4567")
    }
}
