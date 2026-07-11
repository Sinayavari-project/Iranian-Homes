import SwiftUI

/// A large tappable choice card — used for role selection, section pickers,
/// and other "choose one of a few options" moments. Selected state is
/// communicated through border color, background tint, and a trailing
/// checkmark, never through color alone (see Design System §18 Accessibility).
public struct SofrinoSelectionCard: View {
    private let title: String
    private let subtitle: String
    private let systemImage: String
    private let isSelected: Bool
    private let section: SofrinoSection
    private let action: () -> Void

    public init(
        title: String,
        subtitle: String,
        systemImage: String,
        isSelected: Bool,
        section: SofrinoSection = .restaurant,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.section = section
        self.action = action
    }

    public var body: some View {
        Button {
            SofrinoHaptics.select()
            action()
        } label: {
            HStack(spacing: SofrinoSpacing.space5) {
                ZStack {
                    Circle()
                        .fill(isSelected ? section.accentSubtle : SofrinoColor.Neutral.n100)
                        .frame(width: 48, height: 48)
                    Image(systemName: systemImage)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(isSelected ? section.accentStrong : SofrinoColor.Neutral.n500)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .sofrinoTextStyle(SofrinoTypography.titleMD)
                        .foregroundStyle(SofrinoColor.Neutral.n900)
                    Text(subtitle)
                        .sofrinoTextStyle(SofrinoTypography.bodySM)
                        .foregroundStyle(SofrinoColor.Neutral.n500)
                }

                Spacer(minLength: 0)

                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? section.accent : SofrinoColor.Neutral.n300, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(section.accent)
                            .frame(width: 14, height: 14)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .padding(SofrinoSpacing.space6)
            .background(SofrinoColor.Neutral.n50)
            .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.xl, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: SofrinoRadius.xl, style: .continuous)
                    .strokeBorder(isSelected ? section.accent : SofrinoColor.Neutral.n150, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .animation(SofrinoMotion.springSnappy, value: isSelected)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

#Preview("Selection Cards") {
    VStack(spacing: 12) {
        SofrinoSelectionCard(
            title: "Restaurant",
            subtitle: "I buy supplies for my kitchen",
            systemImage: "fork.knife",
            isSelected: true
        ) {}
        SofrinoSelectionCard(
            title: "Supplier",
            subtitle: "I sell to restaurants",
            systemImage: "shippingbox.fill",
            isSelected: false
        ) {}
    }
    .padding()
}
