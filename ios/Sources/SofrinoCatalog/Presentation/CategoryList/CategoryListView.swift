import SwiftUI
import SofrinoCore
import SofrinoDesignSystem

public struct CategoryListView: View {
    @State private var viewModel: CategoryListViewModel
    private let reachability: any ReachabilityMonitoring

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    public init(viewModel: @autoclosure @escaping () -> CategoryListViewModel, reachability: any ReachabilityMonitoring) {
        self._viewModel = State(wrappedValue: viewModel())
        self.reachability = reachability
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SofrinoSpacing.space6) {
                SofrinoSearchField(text: $viewModel.searchText)
                    .onSubmit { viewModel.submitSearch() }
                    .padding(.horizontal, SofrinoSpacing.screenMargin)
                    .padding(.top, SofrinoSpacing.space4)

                if viewModel.isOffline {
                    SofrinoBanner("You're offline. Showing the last-known catalog.", style: .warning)
                        .padding(.horizontal, SofrinoSpacing.screenMargin)
                }

                content
            }
            .padding(.bottom, SofrinoSpacing.space10)
        }
        .background(SofrinoColor.Neutral.n0)
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.onAccountTapped?()
                } label: {
                    Image(systemName: "person.crop.circle")
                        .foregroundStyle(SofrinoColor.Neutral.n700)
                }
                .accessibilityLabel("Account")
            }
        }
        .task { await viewModel.load() }
        .refreshable { await viewModel.load() }
        .onAppear {
            viewModel.isOffline = !reachability.isConnected
            reachability.onConnectivityChange { isConnected in
                viewModel.isOffline = !isConnected
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            skeletonGrid

        case .loaded(let categories) where categories.isEmpty:
            SofrinoEmptyState(
                systemImage: "square.grid.2x2",
                title: "No categories yet",
                subtitle: "Check back soon — new categories are added regularly."
            )

        case .loaded(let categories):
            LazyVGrid(columns: columns, spacing: SofrinoSpacing.space6) {
                ForEach(categories) { category in
                    SofrinoCategoryTile(
                        title: category.name,
                        systemImage: category.iconSystemImage,
                        imageURL: category.imageURL,
                        tint: Color(hex: category.tintHex)
                    ) {
                        viewModel.selectCategory(category)
                    }
                }
            }
            .padding(.horizontal, SofrinoSpacing.screenMargin)

        case .failed(let message):
            SofrinoEmptyState(
                systemImage: "wifi.slash",
                title: "Couldn't load categories",
                subtitle: message,
                actionTitle: "Retry"
            ) {
                Task { await viewModel.load() }
            }
        }
    }

    private var skeletonGrid: some View {
        LazyVGrid(columns: columns, spacing: SofrinoSpacing.space6) {
            ForEach(0..<6, id: \.self) { _ in
                VStack(spacing: SofrinoSpacing.space3) {
                    SofrinoSkeletonBlock(cornerRadius: SofrinoRadius.lg)
                        .aspectRatio(1, contentMode: .fit)
                    SofrinoSkeletonBlock(width: 60, height: 10)
                }
            }
        }
        .padding(.horizontal, SofrinoSpacing.screenMargin)
    }
}
