import SwiftUI

/// Text input from the Sofrino Design System (Section 8: Inputs).
///
/// Always renders a persistent label above the field — placeholder text is
/// never used as a substitute for a label, per the design system's input rules.
public struct SofrinoTextField: View {
    private let label: String
    private let placeholder: String
    @Binding private var text: String
    private let helperText: String?
    private let errorText: String?
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let isCompact: Bool
    private let section: SofrinoSection
    private let leadingIcon: Image?

    @FocusState private var isFocused: Bool

    public init(
        label: String,
        placeholder: String,
        text: Binding<String>,
        helperText: String? = nil,
        errorText: String? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        isCompact: Bool = false,
        section: SofrinoSection = .restaurant,
        leadingIcon: Image? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.helperText = helperText
        self.errorText = errorText
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.isCompact = isCompact
        self.section = section
        self.leadingIcon = leadingIcon
    }

    private var hasError: Bool { errorText != nil }

    public var body: some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            Text(label)
                .sofrinoTextStyle(SofrinoTypography.labelMD)
                .foregroundStyle(SofrinoColor.Neutral.n600)

            HStack(spacing: SofrinoSpacing.space3) {
                if let leadingIcon {
                    leadingIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(SofrinoColor.Neutral.n400)
                }

                TextField(placeholder, text: $text)
                    .sofrinoTextStyle(SofrinoTypography.bodyLG)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .focused($isFocused)
                    .autocorrectionDisabled()

                if !text.isEmpty {
                    Button {
                        text = ""
                        SofrinoHaptics.tap()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(SofrinoColor.Neutral.n400)
                    }
                    .accessibilityLabel("Clear")
                }
            }
            .padding(.horizontal, SofrinoSpacing.space6)
            .frame(height: isCompact ? 40 : 48)
            .background(SofrinoColor.Neutral.n100)
            .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: SofrinoRadius.md, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: isFocused || hasError ? 2 : 1)
            )
            .animation(SofrinoMotion.springSnappy, value: isFocused)
            .animation(SofrinoMotion.springSnappy, value: hasError)

            if let errorText {
                Text(errorText)
                    .sofrinoTextStyle(SofrinoTypography.bodySM)
                    .foregroundStyle(SofrinoColor.error)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else if let helperText {
                Text(helperText)
                    .sofrinoTextStyle(SofrinoTypography.bodySM)
                    .foregroundStyle(SofrinoColor.Neutral.n500)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var borderColor: Color {
        if hasError { return SofrinoColor.error }
        if isFocused { return section.accent }
        return SofrinoColor.Neutral.n200
    }
}

#Preview("Text Field States") {
    VStack(spacing: 20) {
        SofrinoTextField(
            label: "Phone Number",
            placeholder: "50 123 4567",
            text: .constant(""),
            helperText: "We'll send a verification code",
            keyboardType: .phonePad
        )
        SofrinoTextField(
            label: "Trade License Number",
            placeholder: "123456",
            text: .constant("12345"),
            errorText: "Trade license number must be 6 digits"
        )
    }
    .padding()
}
