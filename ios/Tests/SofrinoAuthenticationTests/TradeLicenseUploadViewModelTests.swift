import XCTest
@testable import SofrinoAuthentication

@MainActor
final class TradeLicenseUploadViewModelTests: XCTestCase {
    private func makeViewModel(repository: MockAuthRepository = MockAuthRepository()) -> TradeLicenseUploadViewModel {
        TradeLicenseUploadViewModel(userID: "user-1", repository: repository)
    }

    func testCannotSubmitWithoutAllFields() {
        let viewModel = makeViewModel()
        XCTAssertFalse(viewModel.canSubmit)

        viewModel.licenseNumber = "123456"
        XCTAssertFalse(viewModel.canSubmit, "Missing document data should still block submission")

        viewModel.documentData = Data([0x01, 0x02])
        XCTAssertTrue(viewModel.canSubmit)
    }

    func testRejectsNonSixDigitLicenseNumber() {
        let viewModel = makeViewModel()
        viewModel.licenseNumber = "123"
        viewModel.documentData = Data([0x01])
        XCTAssertFalse(viewModel.isNumberValid)
        XCTAssertFalse(viewModel.canSubmit)
    }

    func testRejectsPastExpiryDate() {
        let viewModel = makeViewModel()
        viewModel.expiryDate = Date().addingTimeInterval(-86_400)
        XCTAssertFalse(viewModel.isExpiryValid)
    }

    func testSuccessfulSubmitInvokesCallback() async {
        let repository = MockAuthRepository()
        let expectedUser = AuthUser(id: "user-1", phoneNumber: "", kycStatus: .pending)
        repository.submitTradeLicenseResult = .success(expectedUser)

        let viewModel = makeViewModel(repository: repository)
        viewModel.licenseNumber = "123456"
        viewModel.documentData = Data([0x01, 0x02, 0x03])

        var receivedUser: AuthUser?
        viewModel.onSubmitted = { receivedUser = $0 }

        await viewModel.submit()

        XCTAssertEqual(repository.submitTradeLicenseCallCount, 1)
        XCTAssertEqual(receivedUser, expectedUser)
        XCTAssertEqual(viewModel.submitState, .idle)
    }

    func testOfflineSubmitReportsQueuedState() async {
        let repository = MockAuthRepository()
        let expectedUser = AuthUser(id: "user-1", phoneNumber: "", kycStatus: .pending)
        repository.submitTradeLicenseResult = .success(expectedUser)

        let viewModel = makeViewModel(repository: repository)
        viewModel.isOffline = true
        viewModel.licenseNumber = "123456"
        viewModel.documentData = Data([0x01])

        await viewModel.submit()

        XCTAssertEqual(viewModel.submitState, .queuedOffline)
    }
}
