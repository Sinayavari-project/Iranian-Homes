import XCTest
@testable import SofrinoCatalog
import SofrinoCore

private final class InMemoryOfflineCache: OfflineCaching, @unchecked Sendable {
    private var storage: [String: Data] = [:]

    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        storage[key] = try JSONEncoder.sofrinoDefault.encode(value)
    }

    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = storage[key] else { return nil }
        return try? JSONDecoder.sofrinoDefault.decode(T.self, from: data)
    }

    func remove(forKey key: String) { storage.removeValue(forKey: key) }
    func clear() { storage.removeAll() }
}

final class OfflineCachingCatalogRepositoryTests: XCTestCase {
    func testFetchCategoriesPopulatesCache() async throws {
        let inner = MockCatalogRepository()
        inner.fetchCategoriesResult = .success([.fixture(id: "cat-1", name: "Fresh Produce")])
        let sut = OfflineCachingCatalogRepository(inner: inner, cache: InMemoryOfflineCache())

        XCTAssertTrue(sut.cachedCategories().isEmpty, "Nothing cached before the first fetch")

        _ = try await sut.fetchCategories()

        XCTAssertEqual(sut.cachedCategories().first?.name, "Fresh Produce")
    }

    func testFetchProductPopulatesCache() async throws {
        let inner = MockCatalogRepository()
        inner.fetchProductResult = .success(.fixture(id: "prod-1", name: "Chicken Breast"))
        let sut = OfflineCachingCatalogRepository(inner: inner, cache: InMemoryOfflineCache())

        XCTAssertNil(sut.cachedProduct(id: "prod-1"))

        _ = try await sut.fetchProduct(id: "prod-1")

        XCTAssertEqual(sut.cachedProduct(id: "prod-1")?.name, "Chicken Breast")
    }

    func testFetchProductsPassesThroughWithoutTouchingCache() async throws {
        let inner = MockCatalogRepository()
        let products = [Product.fixture(id: "prod-1")]
        inner.fetchProductsHandler = { _ in .success(ProductPage(items: products, hasMore: false)) }
        let sut = OfflineCachingCatalogRepository(inner: inner, cache: InMemoryOfflineCache())

        let page = try await sut.fetchProducts(query: ProductQuery())

        XCTAssertEqual(page.items, products)
        XCTAssertEqual(inner.fetchProductsCallCount, 1)
    }

    func testFailedFetchCategoriesDoesNotClearExistingCache() async {
        let inner = MockCatalogRepository()
        inner.fetchCategoriesResult = .success([.fixture(id: "cat-1", name: "Fresh Produce")])
        let sut = OfflineCachingCatalogRepository(inner: inner, cache: InMemoryOfflineCache())
        _ = try? await sut.fetchCategories()

        inner.fetchCategoriesResult = .failure(CatalogError.network(.offline))
        _ = try? await sut.fetchCategories()

        XCTAssertEqual(sut.cachedCategories().first?.name, "Fresh Produce")
    }
}
