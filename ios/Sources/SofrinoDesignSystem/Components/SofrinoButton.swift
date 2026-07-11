import SwiftUI

/// Button hierarchy from the Sofrino Design System (Section 6: Buttons).
public enum SofrinoButtonVariant: Sendable {
    case primary
    case secondary
    case tertiary
    case destructive
    case ghost
}

public enum SofrinoButtonSize: Sendable {
    case xl, lg, md, sm

    var height: CGFloat {
        switch self {
        case .xl: return 56
        case .lg: return 48
        case .md: return 40
        case .sm: return 32
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .xl: return 24
        case .lg: return 20
        case .md: return 16
        case .sm: return 12
        }
    }

    var textStyle: SofrinoTextStyle {
        switch self {
        case .xl, .lg: return SofrinoTypography.labelLG
        case .md: return SofrinoTypography.labelMD
        case .sm: return SofrinoTypography.labelSM
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .xl: return SofrinoRadius.xl
        case .lg: return SofrinoRadius.lg
        case .md: return SofrinoRadius.md
        case .sm: return SofrinoRadius.sm
        }
    }
}

/// A Sofrino primary/secondary/tertiary/destructive/ghost button.
///
/// Implements the full state machine from the design system: default,
/// pressed (scale 0.97 + opacity 0.7, 80ms), disabled (opacity 0.4),
/// and loading (spinner replaces label, button stays the same width).
public struct SofrinoButton: View {
    private let title: String
    private let icon: Image?
    private let variant: SofrinoButtonVariant
    private let size: SofrinoButtonSize
    private let section: SofrinoSection
    private let isLoading: Bool
    private let isDisabled: Bool
    private let fullWidth: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        icon: Image? = nil,
        variant: SofrinoButtonVariant = .primary,
        size: SofrinoButtonSize = .lg,
        section: SofrinoSection = .restaurant,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        fullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.variant = variant
        self.size = size
        self.section = section
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.fullWidth = fullWidth
        self.action = action
    }

    public var body: some View {
        Button(action: handleTap) {
            HStack(spacing: SofrinoSpacing.space2) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(foregroundColor)
                        .frame(width: 16, height: 16)
                } else {
                    if let icon {
                        icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    Text(title)
                        .sofrinoTextStyle(size.textStyle)
                        .lineLimit(1)
                }
            }
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, size.horizontalPadding)
            .frame(height: size.height)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(background)
            .overlay(border)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
        }
        .buttonStyle(SofrinoButtonPressStyle())
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.4 : 1.0)
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
    }

    private func handleTap() {
        SofrinoHaptics.tap()
        action()
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:
            LinearGradient(
                colors: [section.accent, section.accentStrong],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .secondary:
            SofrinoColor.Neutral.n100
        case .tertiary, .ghost:
            Color.clear
        case .destructive:
            SofrinoColor.error
        }
    }

    @ViewBuilder
    private var border: some View {
        switch variant {
        case .secondary:
            RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous)
                .strokeBorder(SofrinoColor.Neutral.n200, lineWidth: 1)
        default:
            EmptyView()
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary, .destructive:
            return .white
        case .secondary:
            return SofrinoColor.Neutral.n800
        case .tertiary:
            return section.accentStrong
        case .ghost:
            return SofrinoColor.Neutral.n600
        }
    }
}

/// Press state: scale 0.97 + opacity 0.7 on press-down, spring back on release.
private struct SofrinoButtonPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.easeOut(duration: SofrinoMotion.durationMicro), value: configuration.isPressed)
    }
}

#Preview("Button Variants") {
    VStack(spacing: 16) {
        SofrinoButton("Place Order", size: .xl, fullWidth: true) {}
        SofrinoButton("Save Draft", variant: .secondary) {}
        SofrinoButton("View All", variant: .tertiary) {}
        SofrinoButton("Cancel Order", variant: .destructive) {}
        SofrinoButton("Maybe Later", variant: .ghost) {}
        SofrinoButton("Loading", isLoading: true) {}
        SofrinoButton("Disabled", isDisabled: true) {}
    }
    .padding()
}
