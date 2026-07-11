import Foundation
import SofrinoCore

/// Decorates any `CatalogRepository` with a disk-backed read cache for
/// categories and individual products — the two shapes of catalog data
/// stable enough to be worth showing instantly while a fresh copy loads
/// (Design System §2, "offline-aware, not offline-first"). Paginated
/// product *lists* are deliberately not cached here: search and
/// category-browse results are exactly the data a restaurant buyer needs
/// live (current price, current stock), so a failed fetch surfaces as a
/// retryable error rather than silently serving a stale page.
///
/// Same composition pattern as `OfflineQueuingAuthRepository`: this type
/// knows nothing about Supabase or PostgREST, and `SupabaseCatalogRepository`
/// knows nothing about caching.
public final class OfflineCachingCatalogRepository: CatalogRepository {
    private let inner: CatalogRepository
    private let cache: OfflineCaching
    private let categoriesCacheKey = "categories"
    private let logger = SofrinoLogger(category: "catalog-offline-cache")

    public init(inner: CatalogRepository, cache: OfflineCaching) {
        self.inner = inner
        self.cache = cache
    }

    public func fetchCategories() async throws -> [Category] {
        let categories = try await inner.fetchCategories()
        do {
            try cache.save(categories, forKey: categoriesCacheKey)
        } catch {
            // Non-fatal: the network fetch already succeeded and its
            // result is what's returned. Only the *next* cold start's
            // instant-paint misses out.
            logger.error("Failed to persist categories cache: \(error)")
        }
        return categories
    }

    public func fetchProducts(query: ProductQuery) async throws -> ProductPage {
        try await inner.fetchProducts(query: query)
    }

    public func fetchProduct(id: String) async throws -> Product {
        let product = try await inner.fetchProduct(id: id)
        do {
            try cache.save(product, forKey: productCacheKey(id))
        } catch {
            logger.error("Failed to persist product cache for \(id): \(error)")
        }
        return product
    }

    public func cachedCategories() -> [Category] {
        cache.load([Category].self, forKey: categoriesCacheKey) ?? []
    }

    public func cachedProduct(id: String) -> Product? {
        cache.load(Product.self, forKey: productCacheKey(id))
    }

    private func productCacheKey(_ id: String) -> String {
        "product_\(id)"
    }
}
