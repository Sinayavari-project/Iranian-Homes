import SwiftUI
import SofrinoCore
import SofrinoDesignSystem
import SofrinoAuthentication

/// The app's top-level switch: authenticated users see the main app shell,
/// everyone else sees the auth flow. This is the only place that reads
/// `SessionStore.isAuthenticated` directly — every other screen either is
/// inside the auth flow or assumes it's already running inside an
/// authenticated context.
public struct RootView: View {
    private let container: AppContainer
    @State private var authContainer: AuthenticationContainer?

    public init(container: AppContainer) {
        self.container = container
    }

    public var body: some View {
        Group {
            if container.sessionStore.isAuthenticated {
                // The Home Screen feature (docs/sofrino-home-screen.md) is
                // built next; this is an honest placeholder for the
                // authenticated app shell, not a stand-in inside the
                // Authentication feature itself.
                SignedInPlaceholderView(onSignOut: signOut)
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
                    .task { authContainer = AuthenticationContainer(appContainer: container) }
            }
        }
        .animation(SofrinoMotion.springSmooth, value: container.sessionStore.isAuthenticated)
    }

    private func signOut() {
        Task {
            try? await authContainer?.repository.signOut()
        }
    }
}

private struct SignedInPlaceholderView: View {
    let onSignOut: () -> Void

    var body: some View {
        VStack(spacing: SofrinoSpacing.space6) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 48))
                .foregroundStyle(SofrinoColor.Emerald.e500)
            Text("You're signed in")
                .sofrinoTextStyle(SofrinoTypography.displayLG)
            Text("The Sofrino home screen is next up.")
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n500)
            SofrinoButton("Sign Out", variant: .secondary, action: onSignOut)
        }
        .padding()
    }
}
