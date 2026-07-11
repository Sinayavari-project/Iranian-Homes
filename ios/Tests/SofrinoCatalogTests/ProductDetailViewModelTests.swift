import XCTest
@testable import SofrinoCatalog

@MainActor
final class ProductDetailViewModelTests: XCTestCase {
    func testStartsLoadedFromCacheWhenAvailable() {
        let repository = MockCatalogRepository()
        repository.stubbedCachedProduct = .fixture(id: "prod-1", name: "Cached Name")

        let viewModel = ProductDetailViewModel(productID: "prod-1", repository: repository)

        XCTAssertEqual(viewModel.state.value?.name, "Cached Name")
    }

    func testStartsIdleWithNoCache() {
        let viewModel = ProductDetailViewModel(productID: "prod-1", repository: MockCatalogRepository())
        XCTAssertEqual(viewModel.state, .idle)
    }

    func testLoadReplacesCacheWithFreshData() async {
        let repository = MockCatalogRepository()
        repository.stubbedCachedProduct = .fixture(id: "prod-1", name: "Stale Name")
        repository.fetchProductResult = .success(.fixture(id: "prod-1", name: "Fresh Name"))

        let viewModel = ProductDetailViewModel(productID: "prod-1", repository: repository)
        await viewModel.load()

        XCTAssertEqual(viewModel.state.value?.name, "Fresh Name")
    }

    func testFailedRefreshKeepsCachedProductVisible() async {
        let repository = MockCatalogRepository()
        repository.stubbedCachedProduct = .fixture(id: "prod-1", name: "Cached Name")
        repository.fetchProductResult = .failure(CatalogError.network(.offline))

        let viewModel = ProductDetailViewModel(productID: "prod-1", repository: repository)
        await viewModel.load()

        XCTAssertEqual(viewModel.state.value?.name, "Cached Name")
    }

    func testProductNotFoundWithNoCacheSurfacesError() async {
        let repository = MockCatalogRepository()
        repository.fetchProductResult = .failure(CatalogError.productNotFound)

        let viewModel = ProductDetailViewModel(productID: "prod-missing", repository: repository)
        await viewModel.load()

        XCTAssertEqual(viewModel.state.errorMessage, CatalogError.productNotFound.userFacingMessage)
    }
}
