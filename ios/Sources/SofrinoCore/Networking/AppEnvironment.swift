import Foundation

/// Sofrino runs in two modes from the same binary (BRD §1, §9): a
/// production marketplace backed by Supabase, and an investor demo mode
/// backed entirely by local fixtures with zero network dependency. Every
/// repository in the app switches behavior based on this single value.
public enum AppEnvironment: Sendable {
    case production
    case demo

    /// Resolves the active environment from a launch argument or build
    /// configuration, defaulting to `.production`. Demo mode is opted into
    /// explicitly — e.g. via an Xcode scheme launch argument
    /// `-SofrinoDemoMode YES`, or an internal settings toggle at runtime.
    public static func resolve(processInfo: ProcessInfo = .processInfo) -> AppEnvironment {
        if processInfo.arguments.contains("-SofrinoDemoMode") {
            return .demo
        }
        return .production
    }

    public var isDemo: Bool {
        self == .demo
    }
}

/// Supabase project configuration. Values are injected at build time via
/// an `.xcconfig` (never hardcoded, never bundled with secrets beyond the
/// public anon key — see Design System / BRD §10 constraint: "service-role
/// secrets remain server-side only").
public struct SupabaseConfiguration: Sendable {
    public let projectURL: URL
    public let anonKey: String

    public init(projectURL: URL, anonKey: String) {
        self.projectURL = projectURL
        self.anonKey = anonKey
    }

    /// Reads configuration from the app bundle's Info.plist, which in turn
    /// is populated from the active `.xcconfig` (Debug/Release/Demo).
    public static func fromInfoPlist(bundle: Bundle = .main) -> SupabaseConfiguration {
        guard
            let urlString = bundle.object(forInfoDictionaryKey: "SOFRINO_SUPABASE_URL") as? String,
            let url = URL(string: urlString),
            let anonKey = bundle.object(forInfoDictionaryKey: "SOFRINO_SUPABASE_ANON_KEY") as? String,
            !anonKey.isEmpty
        else {
            preconditionFailure(
                "Missing SOFRINO_SUPABASE_URL / SOFRINO_SUPABASE_ANON_KEY in Info.plist. " +
                "Set them via Config/Supabase.xcconfig — see docs/sofrino-ios-architecture.md."
            )
        }
        return SupabaseConfiguration(projectURL: url, anonKey: anonKey)
    }
}
