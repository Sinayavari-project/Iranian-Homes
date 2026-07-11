import SwiftUI

/// Pill-shaped search input from Design System §9 — distinct from
/// `SofrinoTextField`: fully rounded, no persistent label, magnifying
/// glass leading icon, section-accent focus ring.
public struct SofrinoSearchField: View {
    @Binding private var text: String
    private let placeholder: String
    private let section: SofrinoSection
    @FocusState private var isFocused: Bool

    public init(text: Binding<String>, placeholder: String = "Search products, suppliers...", section: SofrinoSection = .restaurant) {
        self._text = text
        self.placeholder = placeholder
        self.section = section
    }

    public var body: some View {
        HStack(spacing: SofrinoSpacing.space3) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(SofrinoColor.Neutral.n400)

            TextField(placeholder, text: $text)
                .sofrinoTextStyle(SofrinoTypography.bodyMD)
                .focused($isFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    text = ""
                    SofrinoHaptics.tap()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(SofrinoColor.Neutral.n400)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, SofrinoSpacing.space5)
        .frame(height: 44)
        .background(SofrinoColor.Neutral.n100)
        .clipShape(Capsule())
        .overlay(
            Capsule().strokeBorder(isFocused ? section.accent : Color.clear, lineWidth: 2)
        )
        .animation(SofrinoMotion.springSnappy, value: isFocused)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search")
    }
}

#Preview("Search Field") {
    VStack(spacing: 16) {
        SofrinoSearchField(text: .constant(""))
        SofrinoSearchField(text: .constant("chicken breast"))
    }
    .padding()
}
