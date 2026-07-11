import SwiftUI
import SofrinoCore
import SofrinoDesignSystem

public struct ProductListView: View {
    @State private var viewModel: ProductListViewModel
    private let reachability: any ReachabilityMonitoring

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    public init(viewModel: @autoclosure @escaping () -> ProductListViewModel, reachability: any ReachabilityMonitoring) {
        self._viewModel = State(wrappedValue: viewModel())
        self.reachability = reachability
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SofrinoSpacing.space6) {
                SofrinoSearchField(text: $viewModel.searchText, placeholder: searchPlaceholder)
                    .padding(.horizontal, SofrinoSpacing.screenMargin)
                    .padding(.top, SofrinoSpacing.space4)

                if viewModel.isOffline {
                    SofrinoBanner("You're offline. Search results may be out of date.", style: .warning)
                        .padding(.horizontal, SofrinoSpacing.screenMargin)
                }

                content
            }
            .padding(.bottom, SofrinoSpacing.space10)
        }
        .background(SofrinoColor.Neutral.n0)
        .navigationTitle(viewModel.context.title)
        .task { await viewModel.loadFirstPage() }
        .refreshable { await viewModel.loadFirstPage() }
        .onAppear {
            viewModel.isOffline = !reachability.isConnected
            reachability.onConnectivityChange { isConnected in
                viewModel.isOffline = !isConnected
            }
        }
    }

    private var searchPlaceholder: String {
        if case .category(_, let name) = viewModel.context {
            return "Search in \(name)"
        }
        return "Search products, suppliers..."
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            skeletonGrid

        case .loaded where viewModel.products.isEmpty:
            emptyState

        case .loaded:
            productGrid

        case .failed(let message):
            SofrinoEmptyState(
                systemImage: "wifi.slash",
                title: "Couldn't load products",
                subtitle: message,
                actionTitle: "Retry"
            ) {
                Task { await viewModel.loadFirstPage() }
            }
        }
    }

    private var productGrid: some View {
        VStack(spacing: SofrinoSpacing.space6) {
            LazyVGrid(columns: columns, spacing: SofrinoSpacing.cardGridGutter) {
                ForEach(viewModel.products) { product in
                    SofrinoProductCard(
                        imageURL: product.imageURL,
                        name: product.name,
                        supplierName: product.supplier.name,
                        isSupplierVerified: product.supplier.isVerified,
                        deliveryEstimate: product.supplier.deliveryEstimate,
                        priceText: product.price.formatted,
                        unitText: "/ \(product.unit)",
                        badge: badge(for: product)
                    ) {
                        viewModel.selectProduct(product)
                    }
                    .onAppear { viewModel.loadMoreIfNeeded(currentItem: product) }
                }
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding(.vertical, SofrinoSpacing.space6)
            }
        }
    }

    private var emptyState: some View {
        Group {
            if viewModel.searchText.isEmpty {
                SofrinoEmptyState(systemImage: "shippingbox", title: "No products in this category yet")
            } else {
                SofrinoEmptyState(
                    systemImage: "magnifyingglass",
                    title: "No results found",
                    subtitle: "Try a different search term."
                )
            }
        }
    }

    private var skeletonGrid: some View {
        LazyVGrid(columns: columns, spacing: SofrinoSpacing.cardGridGutter) {
            ForEach(0..<6, id: \.self) { _ in
                VStack(alignment: .leading, spacing: SofrinoSpacing.space3) {
                    SofrinoSkeletonBlock(cornerRadius: SofrinoRadius.lg)
                        .aspectRatio(1, contentMode: .fit)
                    SofrinoSkeletonBlock(width: 120, height: 14)
                    SofrinoSkeletonBlock(width: 70, height: 10)
                }
            }
        }
        .padding(.horizontal, SofrinoSpacing.screenMargin)
    }

    /// One badge per card, most-attention-worthy signal first: a
    /// meaningful price drop beats a fresh/frozen indicator, since it's
    /// the more actionable signal for a buyer scanning a grid.
    private func badge(for product: Product) -> (text: String, style: SofrinoBadgeStyle)? {
        if let priceBadge = priceChangeBadge(forPercent: product.priceChangePercent, threshold: 5) {
            return priceBadge
        }
        if product.isFresh {
            return ("Fresh", .success)
        }
        if product.isFrozen {
            return ("Frozen", .info)
        }
        return nil
    }
}
