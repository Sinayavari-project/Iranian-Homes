import SwiftUI
import SofrinoDesignSystem

public struct OTPVerificationView: View {
    @State private var viewModel: OTPVerificationViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: @autoclosure @escaping () -> OTPVerificationViewModel) {
        self._viewModel = State(wrappedValue: viewModel())
    }

    private var hasError: Bool {
        if case .failed = viewModel.submitState { return true }
        return false
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SofrinoSpacing.space8) {
                header

                VStack(alignment: .leading, spacing: SofrinoSpacing.space4) {
                    SofrinoOTPField(code: $viewModel.code, hasError: hasError)
                        .sofrinoShake(trigger: hasError)

                    if case .failed(let message) = viewModel.submitState {
                        Text(message)
                            .sofrinoTextStyle(SofrinoTypography.bodySM)
                            .foregroundStyle(SofrinoColor.error)
                            .transition(.opacity)
                    }
                }

                if viewModel.submitState == .verifying {
                    HStack(spacing: SofrinoSpacing.space3) {
                        ProgressView()
                        Text("Verifying…")
                            .sofrinoTextStyle(SofrinoTypography.bodyMD)
                            .foregroundStyle(SofrinoColor.Neutral.n500)
                    }
                }

                resendSection

                Spacer(minLength: SofrinoSpacing.space9)

                Button("Wrong number? Edit it") {
                    dismiss()
                }
                .sofrinoTextStyle(SofrinoTypography.labelMD)
                .foregroundStyle(SofrinoColor.Emerald.e600)
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)
            .padding(.top, SofrinoSpacing.space10)
            .animation(SofrinoMotion.springDefault, value: viewModel.submitState)
        }
        .background(SofrinoColor.Neutral.n0)
        .navigationBarBackButtonHidden(false)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            Text("Enter the code")
                .sofrinoTextStyle(SofrinoTypography.displayXL)
                .foregroundStyle(SofrinoColor.Neutral.n900)
            Text("We sent a 6-digit code to \(viewModel.maskedPhoneNumber)")
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n500)
        }
    }

    private var resendSection: some View {
        HStack(spacing: SofrinoSpacing.space2) {
            Text("Didn't get a code?")
                .sofrinoTextStyle(SofrinoTypography.bodyMD)
                .foregroundStyle(SofrinoColor.Neutral.n500)

            if viewModel.canResend {
                Button {
                    Task { await viewModel.resend() }
                } label: {
                    if viewModel.isResending {
                        ProgressView().scaleEffect(0.7)
                    } else {
                        Text("Resend")
                            .sofrinoTextStyle(SofrinoTypography.labelMD)
                            .foregroundStyle(SofrinoColor.Emerald.e600)
                    }
                }
            } else {
                Text("Resend in \(viewModel.resendCooldownSeconds)s")
                    .sofrinoTextStyle(SofrinoTypography.labelMD)
                    .foregroundStyle(SofrinoColor.Neutral.n400)
                    .contentTransition(.numericText(countsDown: true))
                    .animation(.default, value: viewModel.resendCooldownSeconds)
            }
        }
    }
}
