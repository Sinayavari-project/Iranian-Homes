import SwiftUI

/// Type scale from the Sofrino Design System (Section 1: Typography).
///
/// Uses SF Pro / SF Arabic automatically via the system font — Apple selects
/// the correct glyph set per-script. Tracking is applied where the spec calls
/// for it; SwiftUI's `tracking(_:)` modifier is applied by callers via
/// `SofrinoTextStyle.apply(to:)` rather than baked into `Font` (Font has no
/// native tracking).
public struct SofrinoTextStyle: Sendable {
    public let size: CGFloat
    public let weight: Font.Weight
    public let lineHeight: CGFloat
    public let tracking: CGFloat
    public let design: Font.Design

    public init(
        size: CGFloat,
        weight: Font.Weight,
        lineHeight: CGFloat,
        tracking: CGFloat = 0,
        design: Font.Design = .default
    ) {
        self.size = size
        self.weight = weight
        self.lineHeight = lineHeight
        self.tracking = tracking
        self.design = design
    }

    public var font: Font {
        .system(size: size, weight: weight, design: design)
    }
}

public enum SofrinoTypography {
    public static let displayXL = SofrinoTextStyle(size: 34, weight: .bold, lineHeight: 40, tracking: -0.4)
    public static let displayLG = SofrinoTextStyle(size: 28, weight: .bold, lineHeight: 34, tracking: -0.4)
    public static let displayMD = SofrinoTextStyle(size: 22, weight: .semibold, lineHeight: 28, tracking: -0.2)
    public static let titleLG = SofrinoTextStyle(size: 20, weight: .semibold, lineHeight: 26)
    public static let titleMD = SofrinoTextStyle(size: 17, weight: .semibold, lineHeight: 22)
    public static let titleSM = SofrinoTextStyle(size: 15, weight: .medium, lineHeight: 20)
    public static let bodyLG = SofrinoTextStyle(size: 17, weight: .regular, lineHeight: 24)
    public static let bodyMD = SofrinoTextStyle(size: 15, weight: .regular, lineHeight: 20)
    public static let bodySM = SofrinoTextStyle(size: 13, weight: .regular, lineHeight: 18)
    public static let labelLG = SofrinoTextStyle(size: 15, weight: .medium, lineHeight: 20, tracking: 0.2)
    public static let labelMD = SofrinoTextStyle(size: 13, weight: .medium, lineHeight: 18, tracking: 0.2)
    public static let labelSM = SofrinoTextStyle(size: 11, weight: .medium, lineHeight: 14, tracking: 0.4)
    public static let monoLG = SofrinoTextStyle(size: 17, weight: .regular, lineHeight: 22, design: .monospaced)
    public static let monoMD = SofrinoTextStyle(size: 15, weight: .regular, lineHeight: 20, design: .monospaced)
    public static let monoSM = SofrinoTextStyle(size: 13, weight: .regular, lineHeight: 18, design: .monospaced)
}

/// Applies a `SofrinoTextStyle` — font, line height, and tracking — to a `View`.
public struct SofrinoTextStyleModifier: ViewModifier {
    let style: SofrinoTextStyle

    public func body(content: Content) -> some View {
        content
            .font(style.font)
            .tracking(style.tracking)
            .lineSpacing(style.lineHeight - style.size)
    }
}

public extension View {
    /// Applies a Sofrino Design System text style.
    ///
    /// Example: `Text("Good morning").sofrinoTextStyle(.displayXL)`
    func sofrinoTextStyle(_ style: SofrinoTextStyle) -> some View {
        modifier(SofrinoTextStyleModifier(style: style))
    }
}
