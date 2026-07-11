import SwiftUI

/// Status badge from the Design System §12 — "Delivered," "Pending,"
/// "Verified," "Fresh," "Frozen," etc. Semantic-colored subtle background
/// with matching text, no border, 6pt radius.
public enum SofrinoBadgeStyle: Sendable {
    case success, info, warning, error, gold, section(SofrinoSection)

    var background: Color {
        switch self {
        case .success: return SofrinoColor.successSubtle
        case .info: return SofrinoColor.infoSubtle
        case .warning: return SofrinoColor.warningSubtle
        case .error: return SofrinoColor.errorSubtle
        case .gold: return SofrinoColor.verifiedGold.opacity(0.15)
        case .section(let section): return section.accentSubtle
        }
    }

    var foreground: Color {
        switch self {
        case .success: return SofrinoColor.success
        case .info: return SofrinoColor.info
        case .warning: return SofrinoColor.warning
        case .error: return SofrinoColor.error
        case .gold: return SofrinoColor.verifiedGold
        case .section(let section): return section.accentStrong
        }
    }
}

public struct SofrinoBadge: View {
    private let text: String
    private let style: SofrinoBadgeStyle
    private let systemImage: String?

    public init(_ text: String, style: SofrinoBadgeStyle, systemImage: String? = nil) {
        self.text = text
        self.style = style
        self.systemImage = systemImage
    }

    public var body: some View {
        HStack(spacing: SofrinoSpacing.space1) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 10, weight: .semibold))
            }
            Text(text)
                .sofrinoTextStyle(SofrinoTypography.labelMD)
                .lineLimit(1)
        }
        .foregroundStyle(style.foreground)
        .padding(.horizontal, SofrinoSpacing.space4)
        .frame(height: 24)
        .background(style.background)
        .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.xs, style: .continuous))
    }
}

/// Fully-rounded count badge — cart item count, unread notifications.
/// Positioned by the caller with `.offset` / alignment overlay, per Design
/// System §12 "Count Badge."
public struct SofrinoCountBadge: View {
    private let count: Int
    private let style: SofrinoBadgeStyle

    public init(count: Int, style: SofrinoBadgeStyle = .error) {
        self.count = count
        self.style = style
    }

    public var body: some View {
        Text(count > 99 ? "99+" : "\(count)")
            .sofrinoTextStyle(SofrinoTypography.labelSM)
            .foregroundStyle(.white)
            .padding(.horizontal, count > 9 ? 6 : 0)
            .frame(minWidth: 18, minHeight: 18)
            .background(style.foreground)
            .clipShape(Capsule())
    }
}

#Preview("Badges") {
    VStack(alignment: .leading, spacing: 12) {
        SofrinoBadge("Delivered", style: .success)
        SofrinoBadge("Verified", style: .gold, systemImage: "checkmark.seal.fill")
        SofrinoBadge("Fresh", style: .success)
        SofrinoBadge("New", style: .section(.restaurant))
        SofrinoCountBadge(count: 3)
        SofrinoCountBadge(count: 142)
    }
    .padding()
}
