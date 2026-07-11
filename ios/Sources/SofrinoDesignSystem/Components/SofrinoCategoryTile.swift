import SwiftUI

/// Colorful category tile — the Noon/Okala-style entry point into a
/// product category, referenced throughout the Home Screen spec's
/// category grid and reused as-is for the Catalog feature's category list.
public struct SofrinoCategoryTile: View {
    private let title: String
    private let systemImage: String
    private let imageURL: URL?
    private let tint: Color
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        imageURL: URL? = nil,
        tint: Color,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.imageURL = imageURL
        self.tint = tint
        self.action = action
    }

    public var body: some View {
        Button {
            SofrinoHaptics.tap()
            action()
        } label: {
            VStack(spacing: SofrinoSpacing.space3) {
                ZStack {
                    RoundedRectangle(cornerRadius: SofrinoRadius.lg, style: .continuous)
                        .fill(tint.opacity(0.12))

                    if let imageURL {
                        SofrinoRemoteImage(url: imageURL, contentMode: .fit)
                            .padding(SofrinoSpacing.space5)
                    } else {
                        Image(systemName: systemImage)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(tint)
                    }
                }
                .aspectRatio(1, contentMode: .fit)

                Text(title)
                    .sofrinoTextStyle(SofrinoTypography.labelMD)
                    .foregroundStyle(SofrinoColor.Neutral.n700)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(SofrinoTilePressStyle())
    }
}

private struct SofrinoTilePressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(SofrinoMotion.springSnappy, value: configuration.isPressed)
    }
}

#Preview("Category Tiles") {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        SofrinoCategoryTile(title: "Fresh Produce", systemImage: "leaf.fill", tint: SofrinoColor.Emerald.e500) {}
        SofrinoCategoryTile(title: "Meat & Poultry", systemImage: "fork.knife", tint: SofrinoColor.error) {}
        SofrinoCategoryTile(title: "Dairy", systemImage: "drop.fill", tint: SofrinoColor.Blue.b500) {}
    }
    .padding()
}
