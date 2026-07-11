import Foundation
import SofrinoCore

/// The Catalog feature's composition root — same shape as
/// `SofrinoAuthentication.AuthenticationContainer`: pick a repository once
/// based on `AppEnvironment`, hand out fully-wired view models, and let
/// everything downstream stay ignorant of which repository it's using.
@MainActor
public final class CatalogContainer {
    public let repository: CatalogRepository

    public init(appContainer: AppContainer) {
        switch appContainer.environment {
        case .demo:
            self.repository = DemoCatalogRepository()

        case .production:
            guard let httpClient = appContainer.httpClient else {
                preconditionFailure("Production environment requires a configured HTTPClient")
            }
            let supabaseRepository = SupabaseCatalogRepository(httpClient: httpClient)
            self.repository = OfflineCachingCatalogRepository(
                inner: supabaseRepository,
                cache: OfflineCache(namespace: "catalog")
            )
        }
    }

    public func makeCategoryListViewModel() -> CategoryListViewModel {
        CategoryListViewModel(repository: repository)
    }

    public func makeProductListViewModel(context: ProductListContext) -> ProductListViewModel {
        ProductListViewModel(context: context, repository: repository)
    }

    public func makeProductDetailViewModel(productID: String) -> ProductDetailViewModel {
        ProductDetailViewModel(productID: productID, repository: repository)
    }
}
