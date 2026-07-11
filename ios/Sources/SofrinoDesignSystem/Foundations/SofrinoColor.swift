import SwiftUI

/// Color tokens from the Sofrino Design System (Section 3: Color System).
///
/// Every token resolves automatically for light/dark mode via `Color(light:dark:)`.
/// Values are transcribed directly from `docs/sofrino-design-system.md` — do not
/// hand-tune a value here without updating that source of truth first.
public enum SofrinoColor {

    // MARK: Neutral Scale

    public enum Neutral {
        public static let n0 = Color(light: "#FFFFFF", dark: "#000000")
        public static let n50 = Color(light: "#FAFAF8", dark: "#0C0C0B")
        public static let n100 = Color(light: "#F5F5F2", dark: "#161614")
        public static let n150 = Color(light: "#EDEDEA", dark: "#1E1E1B")
        public static let n200 = Color(light: "#E2E2DE", dark: "#2A2A26")
        public static let n300 = Color(light: "#CDCDC8", dark: "#3D3D37")
        public static let n400 = Color(light: "#A8A8A2", dark: "#5C5C55")
        public static let n500 = Color(light: "#82827C", dark: "#7A7A73")
        public static let n600 = Color(light: "#5C5C56", dark: "#A3A39C")
        public static let n700 = Color(light: "#3D3D38", dark: "#C4C4BE")
        public static let n800 = Color(light: "#1E1E1B", dark: "#E2E2DE")
        public static let n900 = Color(light: "#0C0C0B", dark: "#F5F5F2")
        public static let n950 = Color(light: "#000000", dark: "#FFFFFF")
    }

    // MARK: Section Accents

    public enum Emerald {
        public static let e50 = Color(light: "#ECFDF5", dark: "#022C22")
        public static let e100 = Color(light: "#D1FAE5", dark: "#064E3B")
        public static let e200 = Color(light: "#A7F3D0", dark: "#065F46")
        public static let e300 = Color(light: "#6EE7B7", dark: "#047857")
        public static let e400 = Color(light: "#34D399", dark: "#059669")
        public static let e500 = Color(light: "#10B981", dark: "#10B981")
        public static let e600 = Color(light: "#059669", dark: "#34D399")
        public static let e700 = Color(light: "#047857", dark: "#6EE7B7")
    }

    public enum Blue {
        public static let b50 = Color(light: "#EFF6FF", dark: "#172554")
        public static let b100 = Color(light: "#DBEAFE", dark: "#1E3A5F")
        public static let b200 = Color(light: "#BFDBFE", dark: "#1E40AF")
        public static let b300 = Color(light: "#93C5FD", dark: "#2563EB")
        public static let b400 = Color(light: "#60A5FA", dark: "#3B82F6")
        public static let b500 = Color(light: "#3B82F6", dark: "#3B82F6")
        public static let b600 = Color(light: "#2563EB", dark: "#60A5FA")
        public static let b700 = Color(light: "#1D4ED8", dark: "#93C5FD")
    }

    public enum Amber {
        public static let a50 = Color(light: "#FFFBEB", dark: "#451A03")
        public static let a100 = Color(light: "#FEF3C7", dark: "#78350F")
        public static let a200 = Color(light: "#FDE68A", dark: "#92400E")
        public static let a300 = Color(light: "#FCD34D", dark: "#B45309")
        public static let a400 = Color(light: "#FBBF24", dark: "#D97706")
        public static let a500 = Color(light: "#F59E0B", dark: "#F59E0B")
        public static let a600 = Color(light: "#D97706", dark: "#FBBF24")
        public static let a700 = Color(light: "#B45309", dark: "#FCD34D")
    }

    // MARK: Semantic

    public static let success = Color(light: "#16A34A", dark: "#4ADE80")
    public static let successSubtle = Color(light: "#F0FDF4", dark: "#052E16")
    public static let warning = Color(light: "#CA8A04", dark: "#FACC15")
    public static let warningSubtle = Color(light: "#FEFCE8", dark: "#422006")
    public static let error = Color(light: "#DC2626", dark: "#F87171")
    public static let errorSubtle = Color(light: "#FEF2F2", dark: "#450A0A")
    public static let info = Color(light: "#2563EB", dark: "#60A5FA")
    public static let infoSubtle = Color(light: "#EFF6FF", dark: "#172554")

    // MARK: Special

    public static let verifiedGold = Color(light: "#D4A853", dark: "#E8C36A")
    public static let creditPurple = Color(light: "#7C3AED", dark: "#A78BFA")
    public static let freshGreen = Color(light: "#22C55E", dark: "#4ADE80")
    public static let frozenCyan = Color(light: "#06B6D4", dark: "#22D3EE")
}

/// The three top-level marketplace sections, each carrying its own accent.
/// See Design System §3 "Section Accent Colors" and Home Screen §"Section Switcher".
public enum SofrinoSection: String, CaseIterable, Sendable {
    case restaurant
    case globalImports
    case supermarket

    public var displayName: String {
        switch self {
        case .restaurant: return "Restaurant"
        case .globalImports: return "Imports"
        case .supermarket: return "Market"
        }
    }

    /// The primary accent color (500 weight) for this section.
    public var accent: Color {
        switch self {
        case .restaurant: return SofrinoColor.Emerald.e500
        case .globalImports: return SofrinoColor.Blue.b500
        case .supermarket: return SofrinoColor.Amber.a500
        }
    }

    /// The accent gradient end color (600 weight), used for buttons and hero surfaces.
    public var accentStrong: Color {
        switch self {
        case .restaurant: return SofrinoColor.Emerald.e600
        case .globalImports: return SofrinoColor.Blue.b600
        case .supermarket: return SofrinoColor.Amber.a600
        }
    }

    /// The subtle tint background (50 weight) for this section.
    public var accentSubtle: Color {
        switch self {
        case .restaurant: return SofrinoColor.Emerald.e50
        case .globalImports: return SofrinoColor.Blue.b50
        case .supermarket: return SofrinoColor.Amber.a50
        }
    }
}
