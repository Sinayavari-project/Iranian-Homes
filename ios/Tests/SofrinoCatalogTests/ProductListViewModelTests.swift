import XCTest
@testable import SofrinoCatalog

@MainActor
final class ProductListViewModelTests: XCTestCase {
    func testCategoryContextSeedsQueryWithCategoryID() async {
        let repository = MockCatalogRepository()
        repository.fetchProductsHandler = { _ in .success(.empty) }

        let viewModel = ProductListViewModel(context: .category(id: "cat-meat", name: "Meat"), repository: repository)
        await viewModel.loadFirstPage()

        XCTAssertEqual(repository.lastQuery?.categoryID, "cat-meat")
        XCTAssertEqual(repository.lastQuery?.offset, 0)
    }

    func testSearchContextSeedsQueryWithSearchText() async {
        let repository = MockCatalogRepository()
        repository.fetchProductsHandler = { _ in .success(.empty) }

        let viewModel = ProductListViewModel(context: .search(initialText: "salmon"), repository: repository)
        await viewModel.loadFirstPage()

        XCTAssertEqual(repository.lastQuery?.searchText, "salmon")
    }

    func testLoadFirstPagePopulatesProductsAndHasMore() async {
        let repository = MockCatalogRepository()
        let products = (0..<20).map { Product.fixture(id: "prod-\($0)") }
        repository.fetchProductsHandler = { _ in .success(ProductPage(items: products, hasMore: true)) }

        let viewModel = ProductListViewModel(context: .category(id: "cat-meat", name: "Meat"), repository: repository)
        await viewModel.loadFirstPage()

        XCTAssertEqual(viewModel.products.count, 20)
        XCTAssertTrue(viewModel.hasMore)
        XCTAssertEqual(viewModel.state.value?.count, 20)
    }

    func testLoadMoreIfNeededNearEndFetchesNextPage() async {
        let repository = MockCatalogRepository()
        let firstPage = (0..<20).map { Product.fixture(id: "prod-\($0)") }
        let secondPage = (20..<25).map { Product.fixture(id: "prod-\($0)") }

        var callCount = 0
        repository.fetchProductsHandler = { query in
            callCount += 1
            if query.offset == 0 {
                return .success(ProductPage(items: firstPage, hasMore: true))
            } else {
                return .success(ProductPage(items: secondPage, hasMore: false))
            }
        }

        let viewModel = ProductListViewModel(context: .category(id: "cat-meat", name: "Meat"), repository: repository)
        await viewModel.loadFirstPage()

        // Trigger with an item near the end of the first page (index 17 of 20, threshold is last 5).
        viewModel.loadMoreIfNeeded(currentItem: firstPage[17])
        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertEqual(viewModel.products.count, 25)
        XCTAssertFalse(viewModel.hasMore)
        XCTAssertEqual(callCount, 2)
    }

    func testLoadMoreIfNeededFarFromEndDoesNothing() async {
        let repository = MockCatalogRepository()
        let firstPage = (0..<20).map { Product.fixture(id: "prod-\($0)") }
        repository.fetchProductsHandler = { _ in .success(ProductPage(items: firstPage, hasMore: true)) }

        let viewModel = ProductListViewModel(context: .category(id: "cat-meat", name: "Meat"), repository: repository)
        await viewModel.loadFirstPage()

        viewModel.loadMoreIfNeeded(currentItem: firstPage[0])
        try? await Task.sleep(for: .milliseconds(50))

        XCTAssertEqual(viewModel.products.count, 20, "Should not have fetched a second page yet")
        XCTAssertEqual(repository.fetchProductsCallCount, 1)
    }

    func testSearchTextEditDebouncesAndReloadsFirstPage() async {
        let repository = MockCatalogRepository()
        repository.fetchProductsHandler = { _ in .success(.empty) }

        let viewModel = ProductListViewModel(context: .search(initialText: ""), repository: repository)
        let initialCallCount = repository.fetchProductsCallCount

        viewModel.searchText = "s"
        viewModel.searchText = "sa"
        viewModel.searchText = "sal"
        viewModel.searchText = "salmon"

        // Debounce window is 350ms; nothing should have fired yet.
        try? await Task.sleep(for: .milliseconds(100))
        XCTAssertEqual(repository.fetchProductsCallCount, initialCallCount)

        try? await Task.sleep(for: .milliseconds(400))
        XCTAssertEqual(repository.fetchProductsCallCount, initialCallCount + 1)
        XCTAssertEqual(repository.lastQuery?.searchText, "salmon")
    }

    func testFailedFirstPageSurfacesError() async {
        let repository = MockCatalogRepository()
        repository.fetchProductsHandler = { _ in .failure(CatalogError.network(.offline)) }

        let viewModel = ProductListViewModel(context: .category(id: "cat-meat", name: "Meat"), repository: repository)
        await viewModel.loadFirstPage()

        guard case .failed = viewModel.state else {
            return XCTFail("Expected .failed state")
        }
    }

    func testSelectProductForwardsToCallback() async {
        let repository = MockCatalogRepository()
        let viewModel = ProductListViewModel(context: .category(id: "cat-meat", name: "Meat"), repository: repository)

        var received: Product?
        viewModel.onProductSelected = { received = $0 }

        let product = Product.fixture()
        viewModel.selectProduct(product)

        XCTAssertEqual(received, product)
    }
}
