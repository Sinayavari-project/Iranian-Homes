import Foundation

/// The app's composition root for cross-cutting infrastructure.
///
/// Sofrino does not use a global service locator — every view model
/// receives its dependencies through its initializer, so it can be
/// constructed in a `#Preview` or unit test without touching this type.
/// `AppContainer` exists solely to build the small set of *shared*
/// singletons (session, networking, reachability) once at launch and hand
/// them to each feature module's own container (e.g.
/// `AuthenticationContainer`), which then constructs that feature's
/// repositories and view models.
@MainActor
public final class AppContainer {
    public let environment: AppEnvironment
    public let sessionStore: SessionStore
    public let reachability: any ReachabilityMonitoring
    public let httpClient: HTTPClientProtocol?

    public init(environment: AppEnvironment = .resolve()) {
        self.environment = environment
        let keychain = KeychainStore()
        let sessionStore = SessionStore(keychain: keychain)
        self.sessionStore = sessionStore
        self.reachability = Reachability.shared

        switch environment {
        case .production:
            let configuration = SupabaseConfiguration.fromInfoPlist()
            self.httpClient = SupabaseHTTPClient(
                configuration: configuration,
                sessionStore: sessionStore,
                reachability: reachability
            )
        case .demo:
            // Demo mode never talks to the network — see BRD §11 "Demo
            // instability during investor pitch" risk. Feature containers
            // check `environment` and construct their local-fixture
            // repository instead of reading `httpClient`.
            self.httpClient = nil
        }
    }
}
