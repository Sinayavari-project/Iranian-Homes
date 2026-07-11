import SwiftUI
import SofrinoCore
import SofrinoDesignSystem

private enum CatalogRoute: Hashable {
    case productList(ProductListContext)
    case productDetail(id: String)
}

/// The single public entry point into the Catalog feature — same
/// coordinator shape as `SofrinoAuthentication.AuthFlowView`: one
/// `NavigationStack`, one place that knows the screen order, every view
/// model's navigation callback wired here and nowhere else.
public struct CatalogFlowView: View {
    private let container: CatalogContainer
    private let reachability: any ReachabilityMonitoring
    private let onAccountTapped: (() -> Void)?

    @State private var path: [CatalogRoute] = []

    public init(
        container: CatalogContainer,
        reachability: any ReachabilityMonitoring,
        onAccountTapped: (() -> Void)? = nil
    ) {
        self.container = container
        self.reachability = reachability
        self.onAccountTapped = onAccountTapped
    }

    public var body: some View {
        NavigationStack(path: $path) {
            CategoryListView(
                viewModel: makeCategoryListViewModel(),
                reachability: reachability
            )
            .navigationDestination(for: CatalogRoute.self) { route in
                switch route {
                case .productList(let context):
                    ProductListView(
                        viewModel: makeProductListViewModel(context: context),
                        reachability: reachability
                    )
                case .productDetail(let id):
                    ProductDetailView(viewModel: container.makeProductDetailViewModel(productID: id))
                }
            }
        }
        .tint(SofrinoColor.Emerald.e600)
    }

    private func makeCategoryListViewModel() -> CategoryListViewModel {
        let viewModel = container.makeCategoryListViewModel()
        viewModel.onCategorySelected = { category in
            path.append(.productList(.category(id: category.id, name: category.name)))
        }
        viewModel.onSearchSubmitted = { searchText in
            path.append(.productList(.search(initialText: searchText)))
        }
        viewModel.onAccountTapped = onAccountTapped
        return viewModel
    }

    private func makeProductListViewModel(context: ProductListContext) -> ProductListViewModel {
        let viewModel = container.makeProductListViewModel(context: context)
        viewModel.onProductSelected = { product in
            path.append(.productDetail(id: product.id))
        }
        return viewModel
    }
}
