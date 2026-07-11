import Foundation
@testable import SofrinoCatalog
import SofrinoCore

/// A fully scriptable `CatalogRepository` test double, same shape as
/// `SofrinoAuthenticationTests.MockAuthRepository`.
final class MockCatalogRepository: CatalogRepository, @unchecked Sendable {
    var fetchCategoriesResult: Result<[Category], Error> = .success([])
    var fetchCategoriesCallCount = 0

    var fetchProductsHandler: ((ProductQuery) -> Result<ProductPage, Error>)?
    var fetchProductsCallCount = 0
    var lastQuery: ProductQuery?

    var fetchProductResult: Result<Product, Error> = .failure(CatalogError.productNotFound)
    var fetchProductCallCount = 0

    var stubbedCachedCategories: [Category] = []
    var stubbedCachedProduct: Product?

    func fetchCategories() async throws -> [Category] {
        fetchCategoriesCallCount += 1
        switch fetchCategoriesResult {
        case .success(let categories): return categories
        case .failure(let error): throw error
        }
    }

    func fetchProducts(query: ProductQuery) async throws -> ProductPage {
        fetchProductsCallCount += 1
        lastQuery = query
        guard let handler = fetchProductsHandler else { return .empty }
        switch handler(query) {
        case .success(let page): return page
        case .failure(let error): throw error
        }
    }

    func fetchProduct(id: String) async throws -> Product {
        fetchProductCallCount += 1
        switch fetchProductResult {
        case .success(let product): return product
        case .failure(let error): throw error
        }
    }

    func cachedCategories() -> [Category] { stubbedCachedCategories }
    func cachedProduct(id: String) -> Product? { stubbedCachedProduct }
}

extension Product {
    static func fixture(
        id: String = "prod-1",
        name: String = "Chicken Breast",
        price: Decimal = 32.50,
        categoryID: String = "cat-meat"
    ) -> Product {
        Product(
            id: id,
            name: name,
            description: "Test product",
            imageURL: nil,
            price: Money(amount: price),
            unit: "kg",
            supplier: SupplierSummary(id: "sup-1", name: "Al Madina Foods", isVerified: true),
            categoryID: categoryID
        )
    }
}

extension Category {
    static func fixture(id: String = "cat-1", name: String = "Fresh Produce") -> Category {
        Category(id: id, name: name, iconSystemImage: "leaf.fill", tintHex: "#10B981")
    }
}
