import Foundation
import SofrinoCore

/// The Authentication feature's composition root. `AppContainer` builds
/// this once at launch and hands it to `AuthFlowView`; it is the only place
/// in the app that decides "production repository vs. demo repository,"
/// so every view model downstream just receives `any AuthRepository` and
/// stays oblivious to which mode is active.
@MainActor
public final class AuthenticationContainer {
    public let repository: AuthRepository

    public init(appContainer: AppContainer) {
        let cache = OfflineCache(namespace: "authentication")

        switch appContainer.environment {
        case .demo:
            self.repository = DemoAuthRepository(cache: cache)

        case .production:
            guard let httpClient = appContainer.httpClient else {
                preconditionFailure("Production environment requires a configured HTTPClient")
            }
            let supabaseRepository = SupabaseAuthRepository(
                httpClient: httpClient,
                sessionStore: appContainer.sessionStore
            )
            self.repository = OfflineQueuingAuthRepository(
                inner: supabaseRepository,
                cache: cache,
                reachability: appContainer.reachability
            )
        }
    }

    public func makePhoneEntryViewModel() -> PhoneEntryViewModel {
        PhoneEntryViewModel(repository: repository)
    }

    public func makeOTPVerificationViewModel(phoneNumber: String) -> OTPVerificationViewModel {
        OTPVerificationViewModel(phoneNumber: phoneNumber, repository: repository)
    }

    public func makeRoleSelectionViewModel(userID: String) -> RoleSelectionViewModel {
        RoleSelectionViewModel(userID: userID, repository: repository)
    }

    public func makeTradeLicenseUploadViewModel(userID: String) -> TradeLicenseUploadViewModel {
        TradeLicenseUploadViewModel(userID: userID, repository: repository)
    }
}
