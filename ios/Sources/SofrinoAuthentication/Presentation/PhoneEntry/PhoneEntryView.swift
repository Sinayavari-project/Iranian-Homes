import SwiftUI
import SofrinoCore
import SofrinoDesignSystem

/// The first screen of the Sofrino auth flow. Phone-only onboarding — no
/// email, no password — because a chef opening this for the first time
/// mid-shift should be ordering supplies again within minutes, not
/// managing a password (BRD §8.1, Product Principle 1 "Chef-speed").
public struct PhoneEntryView: View {
    @State private var viewModel: PhoneEntryViewModel
    @FocusState private var isFieldFocused: Bool
    private let reachability: any ReachabilityMonitoring

    public init(viewModel: @autoclosure @escaping () -> PhoneEntryViewModel, reachability: any ReachabilityMonitoring) {
        self._viewModel = State(wrappedValue: viewModel())
        self.reachability = reachability
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SofrinoSpacing.space8) {
                header

                if viewModel.isOffline {
                    SofrinoBanner("You're offline. Connect to request a verification code.", style: .warning)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                phoneField

                if case .failed(let message) = viewModel.submitState {
                    SofrinoBanner(message, style: .error)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                Spacer(minLength: SofrinoSpacing.space9)

                SofrinoButton(
                    "Send Code",
                    size: .xl,
                    isLoading: viewModel.submitState == .submitting,
                    isDisabled: !viewModel.canSubmit,
                    fullWidth: true
                ) {
                    Task { await viewModel.submit() }
                }

                legalFootnote
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)
            .padding(.top, SofrinoSpacing.space10)
            .animation(SofrinoMotion.springDefault, value: viewModel.submitState)
            .animation(SofrinoMotion.springDefault, value: viewModel.isOffline)
        }
        .background(SofrinoColor.Neutral.n0)
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            viewModel.isOffline = !reachability.isConnected
            reachability.onConnectivityChange { isConnected in
                viewModel.isOffline = !isConnected
            }
            isFieldFocused = true
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            Text("Welcome to Sofrino")
                .sofrinoTextStyle(SofrinoTypography.displayXL)
                .foregroundStyle(SofrinoColor.Neutral.n900)
            Text("Enter your mobile number and we'll send a verification code.")
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n500)
        }
    }

    private var phoneField: some View {
        HStack(spacing: SofrinoSpacing.space3) {
            countryCode
            SofrinoTextField(
                label: "Mobile Number",
                placeholder: "50 123 4567",
                text: Binding(
                    get: { viewModel.parsedPhoneNumber?.formattedNational ?? viewModel.rawInput },
                    set: { viewModel.rawInput = $0 }
                ),
                keyboardType: .phonePad,
                textContentType: .telephoneNumber
            )
            .focused($isFieldFocused)
        }
    }

    private var countryCode: some View {
        HStack(spacing: SofrinoSpacing.space2) {
            Text("🇦🇪")
            Text("+971")
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n700)
        }
        .padding(.horizontal, SofrinoSpacing.space5)
        .frame(height: 48)
        .background(SofrinoColor.Neutral.n100)
        .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.md, style: .continuous))
        .padding(.top, 22) // Aligns with the text field, which sits below its own label.
        .accessibilityHidden(true)
    }

    private var legalFootnote: some View {
        Text("By continuing, you agree to Sofrino's Terms of Service and Privacy Policy.")
            .sofrinoTextStyle(SofrinoTypography.bodySM)
            .foregroundStyle(SofrinoColor.Neutral.n400)
            .multilineTextAlignment(.leading)
    }
}
