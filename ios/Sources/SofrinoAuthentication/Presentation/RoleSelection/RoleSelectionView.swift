import SwiftUI
import SofrinoDesignSystem

public struct RoleSelectionView: View {
    @State private var viewModel: RoleSelectionViewModel

    public init(viewModel: @autoclosure @escaping () -> RoleSelectionViewModel) {
        self._viewModel = State(wrappedValue: viewModel())
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SofrinoSpacing.space8) {
                header

                VStack(spacing: SofrinoSpacing.space4) {
                    ForEach(UserRole.selectable, id: \.self) { role in
                        SofrinoSelectionCard(
                            title: role.displayName,
                            subtitle: role.subtitle,
                            systemImage: role.systemImage,
                            isSelected: viewModel.selectedRole == role
                        ) {
                            viewModel.selectRole(role)
                        }
                    }
                }

                if case .failed(let message) = viewModel.submitState {
                    SofrinoBanner(message, style: .error)
                }

                Spacer(minLength: SofrinoSpacing.space9)

                SofrinoButton(
                    "Continue",
                    size: .xl,
                    isLoading: viewModel.submitState == .submitting,
                    isDisabled: !viewModel.canContinue,
                    fullWidth: true
                ) {
                    Task { await viewModel.confirmSelection() }
                }

                Text("Need to switch later? Just reach out to support.")
                    .sofrinoTextStyle(SofrinoTypography.bodySM)
                    .foregroundStyle(SofrinoColor.Neutral.n400)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)
            .padding(.top, SofrinoSpacing.space10)
            .animation(SofrinoMotion.springDefault, value: viewModel.submitState)
        }
        .background(SofrinoColor.Neutral.n0)
        .navigationBarBackButtonHidden(true)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            Text("How will you use Sofrino?")
                .sofrinoTextStyle(SofrinoTypography.displayXL)
                .foregroundStyle(SofrinoColor.Neutral.n900)
            Text("This shapes everything you see next — pick whichever matches what you do today.")
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n500)
        }
    }
}
