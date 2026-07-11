import SwiftUI

/// Grid-layout product card from Design System §7 "Product Card (Grid)."
///
/// Deliberately takes primitive display values (strings, a URL, an
/// optional badge) rather than a feature's `Product` domain model —
/// `SofrinoDesignSystem` depends on nothing above it, and a domain type
/// from `SofrinoCatalog` (or a future Cart/Orders feature reusing this
/// same card) would invert that. Each feature maps its own model to these
/// parameters at the call site.
public struct SofrinoProductCard: View {
    private let imageURL: URL?
    private let name: String
    private let supplierName: String
    private let priceText: String
    private let unitText: String?
    private let badge: (text: String, style: SofrinoBadgeStyle)?
    private let onAdd: (() -> Void)?
    private let section: SofrinoSection
    private let action: () -> Void

    public init(
        imageURL: URL?,
        name: String,
        supplierName: String,
        priceText: String,
        unitText: String? = nil,
        badge: (text: String, style: SofrinoBadgeStyle)? = nil,
        section: SofrinoSection = .restaurant,
        onAdd: (() -> Void)? = nil,
        action: @escaping () -> Void
    ) {
        self.imageURL = imageURL
        self.name = name
        self.supplierName = supplierName
        self.priceText = priceText
        self.unitText = unitText
        self.badge = badge
        self.section = section
        self.onAdd = onAdd
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    SofrinoRemoteImage(url: imageURL, contentMode: .fill, cornerRadius: 0)
                        .aspectRatio(1, contentMode: .fit)

                    if let badge {
                        SofrinoBadge(badge.text, style: badge.style)
                            .padding(SofrinoSpacing.space3)
                    }
                }
                .clipShape(
                    .rect(
                        topLeadingRadius: SofrinoRadius.lg,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: SofrinoRadius.lg
                    )
                )

                VStack(alignment: .leading, spacing: SofrinoSpacing.space1) {
                    Text(name)
                        .sofrinoTextStyle(SofrinoTypography.titleMD)
                        .foregroundStyle(SofrinoColor.Neutral.n900)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(minHeight: 44, alignment: .top)

                    Text(supplierName)
                        .sofrinoTextStyle(SofrinoTypography.bodySM)
                        .foregroundStyle(SofrinoColor.Neutral.n500)
                        .lineLimit(1)

                    HStack(alignment: .firstTextBaseline, spacing: SofrinoSpacing.space1) {
                        Text(priceText)
                            .sofrinoTextStyle(SofrinoTypography.monoLG)
                            .foregroundStyle(SofrinoColor.Neutral.n900)
                        if let unitText {
                            Text(unitText)
                                .sofrinoTextStyle(SofrinoTypography.bodySM)
                                .foregroundStyle(SofrinoColor.Neutral.n500)
                        }
                    }
                    .padding(.top, SofrinoSpacing.space1)
                }
                .padding(SofrinoSpacing.space5)
            }
            .background(SofrinoColor.Neutral.n50)
            .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.lg, style: .continuous))
            .sofrinoShadow(.subtle)
            .overlay(alignment: .bottomTrailing) {
                if let onAdd {
                    addButton(action: onAdd)
                        .padding(SofrinoSpacing.space4)
                }
            }
        }
        .buttonStyle(SofrinoCardTapStyle())
    }

    private func addButton(action: @escaping () -> Void) -> some View {
        Button {
            SofrinoHaptics.tap()
            action()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(section.accent)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

private struct SofrinoCardTapStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(SofrinoMotion.springDefault, value: configuration.isPressed)
    }
}

#Preview("Product Card") {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        SofrinoProductCard(
            imageURL: nil,
            name: "Wild-Caught Norwegian Salmon",
            supplierName: "Nordic Seafood Co.",
            priceText: "AED 89.00",
            unitText: "/ kg",
            badge: (text: "Fresh", style: .success),
            onAdd: {}
        ) {}
        SofrinoProductCard(
            imageURL: nil,
            name: "Chicken Breast",
            supplierName: "Al Madina Foods",
            priceText: "AED 32.50",
            unitText: "/ kg"
        ) {}
    }
    .padding()
}
