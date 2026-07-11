import SwiftUI
import SofrinoCore
import SofrinoDesignSystem
import SofrinoAuthentication
import SofrinoCatalog

/// The app's top-level switch: authenticated users see the main app shell,
/// everyone else sees the auth flow. This is the only place that reads
/// `SessionStore.isAuthenticated` directly — every other screen either is
/// inside the auth flow or assumes it's already running inside an
/// authenticated context.
public struct RootView: View {
    private let container: AppContainer
    @State private var authContainer: AuthenticationContainer?
    @State private var catalogContainer: CatalogContainer?

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        Group {
            if container.sessionStore.isAuthenticated {
                // The Home Screen feature (docs/sofrino-home-screen.md) is
                // the eventual authenticated landing surface; Catalog is
                // the first real content built for that authenticated
                // shell, so it stands in for the home screen until that
                // feature exists. `CatalogFlowView` owns its own
                // `NavigationStack` — it is not nested in another one here.
                if let catalogContainer {
                    CatalogFlowView(
                        container: catalogContainer,
                        reachability: container.reachability,
                        onAccountTapped: signOut
                    )
                } else {
                    ProgressView()
                        .task { catalogContainer = CatalogContainer(appContainer: container) }
                }
            } else if let authContainer {
                AuthFlowView(
                    container: authContainer,
                    reachability: container.reachability
                ) { _ in
                    // SessionStore already persisted the session inside
                    // the repository during verifyOTP/selectRole/
                    // submitTradeLicense — nothing further to do here but
                    // let the `if` above re-evaluate on next render, which
                    // SwiftUI does automatically since `sessionStore` is
                    // `@Observable`.
                }
            } else {
                ProgressView()
            }
        }
        .animation(SofrinoMotion.springSmooth, value: container.sessionStore.isAuthenticated)
        .task {
            // Built unconditionally, not just on the unauthenticated
            // branch — a user who launches the app already signed in
            // (restored session) still needs a working `signOut()`, which
            // depends on this container's repository.
            if authContainer == nil {
                authContainer = AuthenticationContainer(appContainer: container)
            }
        }
    }

    private func signOut() {
        Task {
            try? await authContainer?.repository.signOut()
            catalogContainer = nil
        }
    }
}
