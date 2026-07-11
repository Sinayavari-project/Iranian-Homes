import Foundation
import Observation
import SofrinoCore
import SofrinoDesignSystem

@MainActor
@Observable
public final class RoleSelectionViewModel {
    public enum SubmitState: Equatable {
        case idle
        case submitting
        case failed(String)
    }

    public var selectedRole: UserRole?
    public private(set) var submitState: SubmitState = .idle

    /// Carries the updated user forward so the coordinator can branch:
    /// suppliers go on to trade license upload, restaurant buyers go
    /// straight to the home screen (BRD §8.1).
    public var onRoleSelected: ((AuthUser) -> Void)?

    private let userID: String
    private let repository: AuthRepository

    public init(userID: String, repository: AuthRepository) {
        self.userID = userID
        self.repository = repository
    }

    public var canContinue: Bool {
        selectedRole != nil && submitState != .submitting
    }

    public func selectRole(_ role: UserRole) {
        selectedRole = role
    }

    public func confirmSelection() async {
        guard let selectedRole else { return }
        submitState = .submitting
        do {
            let user = try await repository.selectRole(selectedRole, for: userID)
            SofrinoHaptics.confirm()
            submitState = .idle
            onRoleSelected?(user)
        } catch let error as AuthError {
            SofrinoHaptics.error()
            submitState = .failed(error.userFacingMessage)
        } catch {
            SofrinoHaptics.error()
            submitState = .failed("Couldn't save your selection. Please try again.")
        }
    }
}
