import SwiftUI

/// Elevation shadow tokens from the Sofrino Design System (Section 21: 3D Depth).
///
/// Shadows are meaningful only in light mode — in dark mode elevation is
/// conveyed by surface brightness instead (see `SofrinoColor.Neutral`), so
/// `SofrinoShadowModifier` resolves to a no-op shadow automatically when the
/// active color scheme is dark.
public struct SofrinoShadowStyle: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    public static let subtle = SofrinoShadowStyle(color: .black.opacity(0.05), radius: 2.5, x: 0, y: 1)
    public static let raised = SofrinoShadowStyle(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    public static let floating = SofrinoShadowStyle(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
    public static let overlay = SofrinoShadowStyle(color: .black.opacity(0.16), radius: 40, x: 0, y: 16)
}

private struct SofrinoShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let style: SofrinoShadowStyle

    func body(content: Content) -> some View {
        content.shadow(
            color: colorScheme == .dark ? .clear : style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
}

public extension View {
    /// Applies a Sofrino elevation shadow. Automatically disabled in dark mode,
    /// per the design system's "depth via surface brightness" rule for dark surfaces.
    func sofrinoShadow(_ style: SofrinoShadowStyle) -> some View {
        modifier(SofrinoShadowModifier(style: style))
    }
}
