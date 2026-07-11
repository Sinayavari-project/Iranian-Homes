import SwiftUI

/// Empty state from Design System §13 — the same three-element structure
/// (icon, title, subtitle, optional CTA) for every empty list, search
/// result, and collection in the app. No screen shows a bare empty
/// `ScrollView`; every one of them routes through this.
public struct SofrinoEmptyState: View {
    private let systemImage: String
    private let title: String
    private let subtitle: String?
    private let actionTitle: String?
    private let action: (() -> Void)?
    private let section: SofrinoSection

    public init(
        systemImage: String,
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        section: SofrinoSection = .restaurant,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.section = section
        self.action = action
    }

    public var body: some View {
        VStack(spacing: SofrinoSpacing.space6) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .thin))
                .foregroundStyle(section.accent.opacity(0.5))

            VStack(spacing: SofrinoSpacing.space2) {
                Text(title)
                    .sofrinoTextStyle(SofrinoTypography.displayLG)
                    .foregroundStyle(SofrinoColor.Neutral.n800)
                    .multilineTextAlignment(.center)

                if let subtitle {
                    Text(subtitle)
                        .sofrinoTextStyle(SofrinoTypography.bodyLG)
                        .foregroundStyle(SofrinoColor.Neutral.n500)
                        .multilineTextAlignment(.center)
                }
            }

            if let actionTitle, let action {
                SofrinoButton(actionTitle, section: section, action: action)
            }
        }
        .padding(SofrinoSpacing.space9)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview("Empty States") {
    VStack(spacing: 24) {
        SofrinoEmptyState(
            systemImage: "magnifyingglass",
            title: "No results found",
            subtitle: "Try a different search term or browse categories",
            actionTitle: "Browse Categories"
        ) {}

        SofrinoEmptyState(
            systemImage: "shippingbox",
            title: "No products yet"
        )
    }
}
