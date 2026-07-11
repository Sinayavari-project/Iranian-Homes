import Foundation
import SofrinoCore

/// The seam between Catalog view models and the outside world — mirrors
/// `SofrinoAuthentication.AuthRepository`'s shape: two conformances
/// (`SupabaseCatalogRepository`, `DemoCatalogRepository`) share this
/// contract, and view models hold `any CatalogRepository` without knowing
/// which one they got.
public protocol CatalogRepository: Sendable {
    func fetchCategories() async throws -> [Category]
    func fetchProducts(query: ProductQuery) async throws -> ProductPage
    func fetchProduct(id: String) async throws -> Product

    /// Best-effort, synchronous, never throws and never touches the
    /// network — for instant paint while `fetchCategories()` is in flight
    /// (Design System §2 principle 4, "offline-aware, not offline-first").
    /// May be empty on a cold start with no prior successful fetch.
    func cachedCategories() -> [Category]

    /// Same instant-paint contract as `cachedCategories()`, for the one
    /// product a detail screen is about to show.
    func cachedProduct(id: String) -> Product?
}

public enum CatalogError: Error, Equatable, Sendable {
    case productNotFound
    case network(NetworkError)

    public var userFacingMessage: String {
        switch self {
        case .productNotFound:
            return "This product is no longer available."
        case .network(let networkError):
            return networkError.userFacingMessage
        }
    }
}
