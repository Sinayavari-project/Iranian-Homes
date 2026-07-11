import SwiftUI

/// Generic card container from the Sofrino Design System (Section 7: Cards).
///
/// Cards never nest (a card inside a card is a list inside a card) and use
/// `shadow-sm` at rest, per the design system's card rules. This wraps that
/// contract so every screen gets identical corner radius, background, and
/// elevation without re-deriving it.
public struct SofrinoCard<Content: View>: View {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let shadow: SofrinoShadowStyle
    private let content: Content

    public init(
        cornerRadius: CGFloat = SofrinoRadius.lg,
        padding: CGFloat = SofrinoSpacing.space6,
        shadow: SofrinoShadowStyle = .subtle,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.shadow = shadow
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(SofrinoColor.Neutral.n50)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .sofrinoShadow(shadow)
    }
}

/// A card that responds to press with the design system's standard
/// press-scale + shadow-intensify treatment (scale 0.98, shadow steps up).
public struct SofrinoPressableCard<Content: View>: View {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let action: () -> Void
    private let content: Content

    @GestureState private var isPressed = false

    public init(
        cornerRadius: CGFloat = SofrinoRadius.lg,
        padding: CGFloat = SofrinoSpacing.space6,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.action = action
        self.content = content()
    }

    public var body: some View {
        Button(action: action) {
            content
                .padding(padding)
                .background(SofrinoColor.Neutral.n50)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        .buttonStyle(SofrinoCardPressStyle())
    }
}

private struct SofrinoCardPressStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(
                color: colorScheme == .dark ? .clear : .black.opacity(configuration.isPressed ? 0.08 : 0.05),
                radius: configuration.isPressed ? 10 : 2.5,
                x: 0,
                y: configuration.isPressed ? 4 : 1
            )
            .animation(SofrinoMotion.springDefault, value: configuration.isPressed)
    }
}
