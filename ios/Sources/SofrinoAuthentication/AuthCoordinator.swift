import SwiftUI
import SofrinoCore
import SofrinoDesignSystem

/// The auth flow's navigation stack. Each destination owns its own view
/// model, constructed lazily by `AuthenticationContainer` and wired with
/// the callback that advances the stack — the coordinator pattern keeps
/// every screen's view model ignorant of what comes next; only this file
/// knows the flow's shape.
private enum AuthRoute: Hashable {
    case otpVerification(phoneNumber: String)
    case roleSelection(userID: String)
    case tradeLicense(userID: String)
}

/// The single public entry point into the Authentication feature.
/// `RootView` presents this whenever `SessionStore.isAuthenticated` is
/// false, and supplies `onAuthenticated` to know when to swap over to the
/// main app shell.
public struct AuthFlowView: View {
    private let container: AuthenticationContainer
    private let reachability: any ReachabilityMonitoring
    private let onAuthenticated: (AuthSession) -> Void

    @State private var path: [AuthRoute] = []

    public init(
        container: AuthenticationContainer,
        reachability: any ReachabilityMonitoring,
        onAuthenticated: @escaping (AuthSession) -> Void
    ) {
        self.container = container
        self.reachability = reachability
        self.onAuthenticated = onAuthenticated
    }

    public var body: some View {
        NavigationStack(path: $path) {
            PhoneEntryView(
                viewModel: makePhoneEntryViewModel(),
                reachability: reachability
            )
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .otpVerification(let phoneNumber):
                    OTPVerificationView(viewModel: makeOTPViewModel(phoneNumber: phoneNumber))
                case .roleSelection(let userID):
                    RoleSelectionView(viewModel: makeRoleSelectionViewModel(userID: userID))
                case .tradeLicense(let userID):
                    TradeLicenseUploadView(
                        viewModel: makeTradeLicenseViewModel(userID: userID),
                        reachability: reachability
                    )
                }
            }
        }
        .tint(SofrinoColor.Emerald.e600)
    }

    // MARK: - View model factories (each wires the callback that drives navigation)

    private func makePhoneEntryViewModel() -> PhoneEntryViewModel {
        let viewModel = container.makePhoneEntryViewModel()
        viewModel.onOTPRequested = { phoneNumber in
            path.append(.otpVerification(phoneNumber: phoneNumber))
        }
        return viewModel
    }

    private func makeOTPViewModel(phoneNumber: String) -> OTPVerificationViewModel {
        let viewModel = container.makeOTPVerificationViewModel(phoneNumber: phoneNumber)
        viewModel.onVerified = { session in
            route(after: session)
        }
        return viewModel
    }

    private func makeRoleSelectionViewModel(userID: String) -> RoleSelectionViewModel {
        let viewModel = container.makeRoleSelectionViewModel(userID: userID)
        viewModel.onRoleSelected = { user in
            if user.role == .supplier, user.kycStatus.isActionable {
                path.append(.tradeLicense(userID: userID))
            } else {
                completeIfPossible()
            }
        }
        return viewModel
    }

    private func makeTradeLicenseViewModel(userID: String) -> TradeLicenseUploadViewModel {
        let viewModel = container.makeTradeLicenseUploadViewModel(userID: userID)
        viewModel.onSubmitted = { _ in
            completeIfPossible()
        }
        return viewModel
    }

    // MARK: - Routing decisions

    private func route(after session: AuthSession) {
        let user = session.user
        if user.role == nil {
            path.append(.roleSelection(userID: user.id))
        } else if user.role == .supplier, user.kycStatus.isActionable {
            path.append(.tradeLicense(userID: user.id))
        } else {
            onAuthenticated(session)
        }
    }

    /// Trade license / role selection endpoints return an `AuthUser`, not a
    /// full `AuthSession` — re-derive the session from the store, which
    /// `SupabaseAuthRepository`/`DemoAuthRepository` already persisted
    /// during `verifyOTP`.
    private func completeIfPossible() {
        Task {
            if let session = await container.repository.restoreSession() {
                onAuthenticated(session)
            }
        }
    }
}
