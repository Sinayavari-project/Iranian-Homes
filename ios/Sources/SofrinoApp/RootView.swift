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
    /// `nil` until the restored session's role has resolved. Resolving it
    /// is what lets this view tell a restaurant buyer from a supplier —
    /// `SessionStore` only knows *that* someone is signed in, not *what*
    /// they are, so this requires a round trip through
    /// `AuthRepository.restoreSession()`.
    @State private var authenticatedRole: UserRole?

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        Group {
            if container.sessionStore.isAuthenticated {
                authenticatedContent
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
        .task(id: container.sessionStore.isAuthenticated) {
            guard container.sessionStore.isAuthenticated else {
                authenticatedRole = nil
                return
            }
            if authContainer == nil {
                authContainer = AuthenticationContainer(appContainer: container)
            }
            let session = await authContainer?.repository.restoreSession()
            authenticatedRole = session?.user.role
        }
    }

    @ViewBuilder
    private var authenticatedContent: some View {
        switch authenticatedRole {
        case .supplier:
            // The Supplier Portal (BRD §8.1: inventory, orders, wallet) is
            // its own future feature. Routing a supplier into the buyer
            // Catalog would be actively wrong — they'd see a shopping grid
            // with nothing to do — so this is an honest placeholder, not a
            // stand-in dressed up as the real thing.
            SupplierPlaceholderView(onSignOut: signOut)

        case .restaurant, .admin, .none:
            // `.none` covers the brief window before `restoreSession()`
            // resolves the role. Defaulting to the buyer catalog here
            // rather than a loading spinner keeps the common case
            // (restaurant buyer, which is nearly every fresh sign-in)
            // feeling instant; a supplier account flips over to the
            // placeholder the moment the role resolves, which is fast —
            // it's a local Keychain-backed read, not a network call.
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
        }
    }

    private func signOut() {
        Task {
            try? await authContainer?.repository.signOut()
            catalogContainer = nil
            authenticatedRole = nil
        }
    }
}

private struct SupplierPlaceholderView: View {
    let onSignOut: () -> Void

    var body: some View {
        VStack(spacing: SofrinoSpacing.space6) {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 48))
                .foregroundStyle(SofrinoColor.Emerald.e500)
            Text("Your Supplier Portal is next")
                .sofrinoTextStyle(SofrinoTypography.displayLG)
                .multilineTextAlignment(.center)
            Text("Inventory, incoming orders, and your wallet will live here. You're verified and ready — this view just isn't built yet.")
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n500)
                .multilineTextAlignment(.center)
            SofrinoButton("Sign Out", variant: .secondary, action: onSignOut)
        }
        .padding(SofrinoSpacing.space9)
    }
}
