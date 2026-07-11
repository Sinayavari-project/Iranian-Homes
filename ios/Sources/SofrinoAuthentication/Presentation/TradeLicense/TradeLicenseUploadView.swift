import SwiftUI
import PhotosUI
import SofrinoCore
import SofrinoDesignSystem

public struct TradeLicenseUploadView: View {
    @State private var viewModel: TradeLicenseUploadViewModel
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isProcessingPhoto = false
    private let reachability: any ReachabilityMonitoring

    public init(
        viewModel: @autoclosure @escaping () -> TradeLicenseUploadViewModel,
        reachability: any ReachabilityMonitoring
    ) {
        self._viewModel = State(wrappedValue: viewModel())
        self.reachability = reachability
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SofrinoSpacing.space8) {
                header

                if viewModel.isOffline {
                    SofrinoBanner(
                        "You're offline. We'll upload this the moment you're back online — you can continue in the meantime.",
                        style: .warning
                    )
                }

                photoPicker

                SofrinoTextField(
                    label: "Trade License Number",
                    placeholder: "123456",
                    text: $viewModel.licenseNumber,
                    errorText: licenseNumberError,
                    keyboardType: .numberPad
                )

                expiryPicker

                if case .failed(let message) = viewModel.submitState {
                    SofrinoBanner(message, style: .error)
                } else if viewModel.submitState == .queuedOffline {
                    SofrinoBanner("Queued — we'll submit this automatically once you're back online.", style: .info)
                }

                Spacer(minLength: SofrinoSpacing.space9)

                SofrinoButton(
                    "Submit for Review",
                    size: .xl,
                    isLoading: viewModel.submitState == .submitting,
                    isDisabled: !viewModel.canSubmit,
                    fullWidth: true
                ) {
                    Task { await viewModel.submit() }
                }
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)
            .padding(.top, SofrinoSpacing.space10)
            .animation(SofrinoMotion.springDefault, value: viewModel.submitState)
        }
        .background(SofrinoColor.Neutral.n0)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.isOffline = !reachability.isConnected
            reachability.onConnectivityChange { isConnected in
                viewModel.isOffline = !isConnected
            }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task { await loadPhoto(newItem) }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            Text("Verify your business")
                .sofrinoTextStyle(SofrinoTypography.displayXL)
                .foregroundStyle(SofrinoColor.Neutral.n900)
            Text("Suppliers need a valid UAE trade license. Review usually takes under 24 hours.")
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n500)
        }
    }

    private var photoPicker: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            ZStack {
                RoundedRectangle(cornerRadius: SofrinoRadius.xl, style: .continuous)
                    .strokeBorder(SofrinoColor.Neutral.n200, style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                    .background(SofrinoColor.Neutral.n50.clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.xl, style: .continuous)))

                if isProcessingPhoto {
                    ProgressView()
                } else if let documentData = viewModel.documentData, let uiImage = UIImage(data: documentData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.xl, style: .continuous))
                } else {
                    VStack(spacing: SofrinoSpacing.space3) {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundStyle(SofrinoColor.Neutral.n400)
                        Text("Upload trade license photo")
                            .sofrinoTextStyle(SofrinoTypography.bodyMD)
                            .foregroundStyle(SofrinoColor.Neutral.n500)
                    }
                }
            }
            .frame(height: 180)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(viewModel.documentData == nil ? "Upload trade license photo" : "Trade license photo selected. Tap to change.")
    }

    private var expiryPicker: some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            Text("Expiry Date")
                .sofrinoTextStyle(SofrinoTypography.labelMD)
                .foregroundStyle(SofrinoColor.Neutral.n600)
            DatePicker("Expiry Date", selection: $viewModel.expiryDate, in: Date.now..., displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .padding(.horizontal, SofrinoSpacing.space6)
                .frame(height: 48)
                .background(SofrinoColor.Neutral.n100)
                .clipShape(RoundedRectangle(cornerRadius: SofrinoRadius.md, style: .continuous))
        }
    }

    private var licenseNumberError: String? {
        guard !viewModel.licenseNumber.isEmpty, !viewModel.isNumberValid else { return nil }
        return "Trade license number must be 6 digits"
    }

    private func loadPhoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        isProcessingPhoto = true
        defer { isProcessingPhoto = false }

        guard
            let rawData = try? await item.loadTransferable(type: Data.self),
            let uiImage = UIImage(data: rawData),
            let compressed = uiImage.jpegData(compressionQuality: 0.6)
        else {
            return
        }
        viewModel.documentData = compressed
    }
}
