import SwiftUI
import SofrinoCore
import SofrinoDesignSystem

public struct ProductDetailView: View {
    @State private var viewModel: ProductDetailViewModel

    public init(viewModel: @autoclosure @escaping () -> ProductDetailViewModel) {
        self._viewModel = State(wrappedValue: viewModel())
    }

    public var body: some View {
        ScrollView {
            switch viewModel.state {
            case .idle, .loading:
                skeleton

            case .loaded(let product):
                loaded(product)

            case .failed(let message):
                SofrinoEmptyState(
                    systemImage: "wifi.slash",
                    title: "Couldn't load this product",
                    subtitle: message,
                    actionTitle: "Retry"
                ) {
                    Task { await viewModel.load() }
                }
                .padding(.top, SofrinoSpacing.space10)
            }
        }
        .background(SofrinoColor.Neutral.n0)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }

    private func loaded(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space7) {
            SofrinoRemoteImage(url: product.imageURL, contentMode: .fill)
                .frame(height: 320)
                .clipped()

            VStack(alignment: .leading, spacing: SofrinoSpacing.space6) {
                header(product)
                priceSection(product)
                supplierCard(product)
                descriptionSection(product)
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)
            .padding(.bottom, SofrinoSpacing.space10)
        }
    }

    private func header(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            HStack(spacing: SofrinoSpacing.space2) {
                if product.isFresh {
                    SofrinoBadge("Fresh", style: .success)
                }
                if product.isFrozen {
                    SofrinoBadge("Frozen", style: .info)
                }
                if let rating = product.rating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(SofrinoColor.Amber.a400)
                        Text(String(format: "%.1f", rating))
                        Text("(\(product.reviewCount))")
                            .foregroundStyle(SofrinoColor.Neutral.n400)
                    }
                    .sofrinoTextStyle(SofrinoTypography.bodySM)
                    .foregroundStyle(SofrinoColor.Neutral.n600)
                }
            }

            Text(product.name)
                .sofrinoTextStyle(SofrinoTypography.displayLG)
                .foregroundStyle(SofrinoColor.Neutral.n900)
        }
    }

    private func priceSection(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            HStack(alignment: .firstTextBaseline, spacing: SofrinoSpacing.space3) {
                Text(product.price.formatted)
                    .sofrinoTextStyle(SofrinoTypography.displayMD)
                    .foregroundStyle(SofrinoColor.Neutral.n900)
                Text("/ \(product.unit)")
                    .sofrinoTextStyle(SofrinoTypography.bodyMD)
                    .foregroundStyle(SofrinoColor.Neutral.n500)

                if let previousPrice = product.previousPrice,
                   let badge = priceChangeBadge(forPercent: product.priceChangePercent) {
                    Text(previousPrice.formatted)
                        .sofrinoTextStyle(SofrinoTypography.monoMD)
                        .foregroundStyle(SofrinoColor.Neutral.n400)
                        .strikethrough()
                    SofrinoBadge(badge.text, style: badge.style)
                }
            }

            Text("Minimum order: \(product.minimumOrderQuantity) \(product.unit)\(product.minimumOrderQuantity == 1 ? "" : "s")")
                .sofrinoTextStyle(SofrinoTypography.bodySM)
                .foregroundStyle(SofrinoColor.Neutral.n500)
        }
    }

    private func supplierCard(_ product: Product) -> some View {
        SofrinoCard {
            HStack(spacing: SofrinoSpacing.space4) {
                Circle()
                    .fill(SofrinoColor.Neutral.n100)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(product.supplier.name.prefix(1))
                            .sofrinoTextStyle(SofrinoTypography.titleMD)
                            .foregroundStyle(SofrinoColor.Neutral.n600)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: SofrinoSpacing.space2) {
                        Text(product.supplier.name)
                            .sofrinoTextStyle(SofrinoTypography.titleMD)
                            .foregroundStyle(SofrinoColor.Neutral.n900)
                        if product.supplier.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(SofrinoColor.verifiedGold)
                        }
                    }
                    if let estimate = product.supplier.deliveryEstimate {
                        Text(estimate)
                            .sofrinoTextStyle(SofrinoTypography.bodySM)
                            .foregroundStyle(SofrinoColor.Neutral.n500)
                    }
                }

                Spacer(minLength: 0)

                if let rating = product.supplier.rating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(SofrinoColor.Amber.a400)
                        Text(String(format: "%.1f", rating))
                            .sofrinoTextStyle(SofrinoTypography.bodySM)
                            .foregroundStyle(SofrinoColor.Neutral.n600)
                    }
                }
            }
        }
    }

    private func descriptionSection(_ product: Product) -> some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space2) {
            Text("Description")
                .sofrinoTextStyle(SofrinoTypography.titleSM)
                .foregroundStyle(SofrinoColor.Neutral.n800)
            Text(product.description)
                .sofrinoTextStyle(SofrinoTypography.bodyLG)
                .foregroundStyle(SofrinoColor.Neutral.n600)
        }
    }

    private var skeleton: some View {
        VStack(alignment: .leading, spacing: SofrinoSpacing.space6) {
            SofrinoSkeletonBlock(height: 320, cornerRadius: 0)
            VStack(alignment: .leading, spacing: SofrinoSpacing.space4) {
                SofrinoSkeletonBlock(width: 220, height: 24)
                SofrinoSkeletonBlock(width: 140, height: 32)
                SofrinoSkeletonBlock(height: 72, cornerRadius: SofrinoRadius.lg)
                SofrinoSkeletonBlock(height: 80)
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)
        }
    }
}
