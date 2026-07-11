import SwiftUI

/// A reusable segmented one-time-passcode input.
///
/// Built from the same input tokens as `SofrinoTextField` (same border,
/// radius, and focus-color language) but rendered as discrete digit boxes,
/// which is the expected pattern for OTP entry. A single invisible
/// `TextField` captures keyboard input; the boxes are a pure visual
/// projection of `code`, keeping exactly one source of truth.
public struct SofrinoOTPField: View {
    private let length: Int
    @Binding private var code: String
    private let section: SofrinoSection
    private let hasError: Bool

    @FocusState private var isFocused: Bool

    public init(
        code: Binding<String>,
        length: Int = 6,
        section: SofrinoSection = .restaurant,
        hasError: Bool = false
    ) {
        self._code = code
        self.length = length
        self.section = section
        self.hasError = hasError
    }

    public var body: some View {
        ZStack {
            // Hidden field captures actual keyboard input.
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .accessibilityLabel("One-time verification code")
                .onChange(of: code) { _, newValue in
                    let digitsOnly = newValue.filter(\.isNumber)
                    code = String(digitsOnly.prefix(length))
                }

            HStack(spacing: SofrinoSpacing.space3) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .allowsHitTesting(false)
        }
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
        .onAppear { isFocused = true }
    }

    private func digitBox(at index: Int) -> some View {
        let characters = Array(code)
        let digit = index < characters.count ? String(characters[index]) : ""
        let isActive = isFocused && index == characters.count
        let isFilled = !digit.isEmpty

        return Text(digit)
            .sofrinoTextStyle(SofrinoTypography.displayMD)
            .foregroundStyle(SofrinoColor.Neutral.n900)
            .frame(width: 48, height: 56)
            .background(SofrinoColor.Neutral.n100)
            .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: SofrinoRadius.md, style: .continuous)
                    .strokeBorder(borderColor(isActive: isActive, isFilled: isFilled), lineWidth: isActive || hasError ? 2 : 1)
            )
            .scaleEffect(isActive ? 1.05 : 1.0)
            .animation(SofrinoMotion.springSnappy, value: isActive)
            .animation(SofrinoMotion.springSnappy, value: isFilled)
    }

    private func borderColor(isActive: Bool, isFilled: Bool) -> Color {
        if hasError { return SofrinoColor.error }
        if isActive { return section.accent }
        if isFilled { return SofrinoColor.Neutral.n300 }
        return SofrinoColor.Neutral.n200
    }
}

#Preview("OTP Field") {
    VStack(spacing: 24) {
        SofrinoOTPField(code: .constant("42"))
        SofrinoOTPField(code: .constant("123456"))
        SofrinoOTPField(code: .constant("42"), hasError: true)
    }
    .padding()
}
