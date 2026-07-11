import SwiftUI

/// Inline status banner — reuses the semantic color language from the
/// Urgent Ribbon (Home Screen §3) in a generic, screen-agnostic form for
/// offline notices, form-level errors, and informational callouts.
public enum SofrinoBannerStyle: Sendable {
    case info, warning, error, success

    var tint: Color {
        switch self {
        case .info: return SofrinoColor.info
        case .warning: return SofrinoColor.warning
        case .error: return SofrinoColor.error
        case .success: return SofrinoColor.success
        }
    }

    var background: Color {
        switch self {
        case .info: return SofrinoColor.infoSubtle
        case .warning: return SofrinoColor.warningSubtle
        case .error: return SofrinoColor.errorSubtle
        case .success: return SofrinoColor.successSubtle
        }
    }

    var systemImage: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        case .success: return "checkmark.circle.fill"
        }
    }
}

public struct SofrinoBanner: View {
    private let message: String
    private let style: SofrinoBannerStyle
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        _ message: String,
        style: SofrinoBannerStyle = .info,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.style = style
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack(spacing: SofrinoSpacing.space4) {
            Image(systemName: style.systemImage)
                .foregroundStyle(style.tint)
                .frame(width: 18, height: 18)

            Text(message)
                .sofrinoTextStyle(SofrinoTypography.bodyMD)
                .foregroundStyle(SofrinoColor.Neutral.n800)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .sofrinoTextStyle(SofrinoTypography.labelMD)
                        .foregroundStyle(style.tint)
                }
            }
        }
        .padding(.horizontal, SofrinoSpacing.space5)
        .padding(.vertical, SofrinoSpacing.space4)
        .background(style.background)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(style.tint)
                .frame(width: 3)
        }
        .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.lg, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview("Banners") {
    VStack(spacing: 12) {
        SofrinoBanner("You're offline. We'll submit this as soon as you're back online.", style: .warning)
        SofrinoBanner("Verification code sent to +971 50 123 4567", style: .info)
        SofrinoBanner("That code didn't match. Try again.", style: .error)
        SofrinoBanner("Phone number verified", style: .success)
    }
    .padding()
}
