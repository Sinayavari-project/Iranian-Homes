import XCTest
@testable import SofrinoCatalog

@MainActor
final class CategoryListViewModelTests: XCTestCase {
    func testStartsLoadedFromCacheWhenAvailable() {
        let repository = MockCatalogRepository()
        repository.stubbedCachedCategories = [.fixture(id: "cat-1", name: "Fresh Produce")]

        let viewModel = CategoryListViewModel(repository: repository)

        XCTAssertEqual(viewModel.state.value?.map(\.name), ["Fresh Produce"])
    }

    func testStartsIdleWithNoCache() {
        let viewModel = CategoryListViewModel(repository: MockCatalogRepository())
        XCTAssertEqual(viewModel.state, .idle)
    }

    func testLoadReplacesCacheWithFreshData() async {
        let repository = MockCatalogRepository()
        repository.stubbedCachedCategories = [.fixture(id: "cat-1", name: "Stale Name")]
        repository.fetchCategoriesResult = .success([.fixture(id: "cat-1", name: "Fresh Produce")])

        let viewModel = CategoryListViewModel(repository: repository)
        await viewModel.load()

        XCTAssertEqual(viewModel.state.value?.first?.name, "Fresh Produce")
    }

    func testFailedRefreshKeepsExistingCacheVisible() async {
        let repository = MockCatalogRepository()
        repository.stubbedCachedCategories = [.fixture(id: "cat-1", name: "Fresh Produce")]
        repository.fetchCategoriesResult = .failure(CatalogError.network(.offline))

        let viewModel = CategoryListViewModel(repository: repository)
        await viewModel.load()

        // Should NOT surface a `.failed` state and blank the screen — the
        // cached categories are still valid and visible.
        XCTAssertEqual(viewModel.state.value?.first?.name, "Fresh Produce")
    }

    func testFailedLoadWithNoCacheSurfacesError() async {
        let repository = MockCatalogRepository()
        repository.fetchCategoriesResult = .failure(CatalogError.network(.offline))

        let viewModel = CategoryListViewModel(repository: repository)
        await viewModel.load()

        guard case .failed = viewModel.state else {
            return XCTFail("Expected .failed state with no cache to fall back to")
        }
    }

    func testSubmitSearchIgnoresBlankText() {
        let viewModel = CategoryListViewModel(repository: MockCatalogRepository())
        var invoked = false
        viewModel.onSearchSubmitted = { _ in invoked = true }

        viewModel.searchText = "   "
        viewModel.submitSearch()

        XCTAssertFalse(invoked)
    }

    func testSubmitSearchTrimsAndForwardsText() {
        let viewModel = CategoryListViewModel(repository: MockCatalogRepository())
        var received: String?
        viewModel.onSearchSubmitted = { received = $0 }

        viewModel.searchText = "  chicken  "
        viewModel.submitSearch()

        XCTAssertEqual(received, "chicken")
    }

    func testSelectCategoryForwardsToCallback() {
        let viewModel = CategoryListViewModel(repository: MockCatalogRepository())
        let category = Category.fixture()
        var received: Category?
        viewModel.onCategorySelected = { received = $0 }

        viewModel.selectCategory(category)

        XCTAssertEqual(received, category)
    }
}
