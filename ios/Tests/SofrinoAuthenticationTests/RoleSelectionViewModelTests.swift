import XCTest
@testable import SofrinoAuthentication

@MainActor
final class RoleSelectionViewModelTests: XCTestCase {
    func testCannotContinueWithoutSelection() {
        let viewModel = RoleSelectionViewModel(userID: "user-1", repository: MockAuthRepository())
        XCTAssertFalse(viewModel.canContinue)
    }

    func testSelectingRoleEnablesContinue() {
        let viewModel = RoleSelectionViewModel(userID: "user-1", repository: MockAuthRepository())
        viewModel.selectRole(.restaurant)
        XCTAssertTrue(viewModel.canContinue)
    }

    func testConfirmSelectionInvokesCallbackOnSuccess() async {
        let repository = MockAuthRepository()
        let expectedUser = AuthUser(id: "user-1", phoneNumber: "+971501234567", role: .supplier)
        repository.selectRoleResult = .success(expectedUser)

        let viewModel = RoleSelectionViewModel(userID: "user-1", repository: repository)
        viewModel.selectRole(.supplier)

        var receivedUser: AuthUser?
        viewModel.onRoleSelected = { receivedUser = $0 }

        await viewModel.confirmSelection()

        XCTAssertEqual(receivedUser, expectedUser)
        XCTAssertEqual(viewModel.submitState, .idle)
    }

    func testConfirmSelectionSurfacesFailure() async {
        let repository = MockAuthRepository()
        repository.selectRoleResult = .failure(AuthError.network(.server(statusCode: 500, message: nil)))

        let viewModel = RoleSelectionViewModel(userID: "user-1", repository: repository)
        viewModel.selectRole(.restaurant)

        await viewModel.confirmSelection()

        guard case .failed = viewModel.submitState else {
            return XCTFail("Expected .failed state")
        }
    }
}
