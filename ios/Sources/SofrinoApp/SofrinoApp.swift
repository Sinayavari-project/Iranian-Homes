import SwiftUI
import SofrinoCore

/// App entry point. This file must live inside the actual Xcode
/// application target (not a Swift package) to compile and run — see
/// `docs/sofrino-ios-architecture.md` for the exact project wiring. It is
/// kept in `SofrinoApp` as an importable library so it can also be
/// referenced from the Xcode Preview host and from UI test targets.
public struct SofrinoAppRoot: App {
    private let container: AppContainer

    public init() {
        self.container = AppContainer()
    }

    public var body: some Scene {
        WindowGroup {
            RootView(container: container)
        }
    }
}
