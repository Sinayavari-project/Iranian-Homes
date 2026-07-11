import Foundation
import SofrinoCore

/// Production `CatalogRepository`, reading directly from Supabase's
/// PostgREST API — same rationale as `SupabaseAuthRepository`: no SDK
/// dependency, every filter fully visible in the query string.
public final class SupabaseCatalogRepository: CatalogRepository {
    private let httpClient: HTTPClientProtocol
    private static let productSelect = "*,supplier:suppliers(id,name,is_verified,rating,delivery_estimate)"

    public init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    public func fetchCategories() async throws -> [Category] {
        do {
            let endpoint = Endpoint(
                path: "rest/v1/categories",
                queryItems: [
                    URLQueryItem(name: "select", value: "*"),
                    URLQueryItem(name: "order", value: "name.asc")
                ]
            )
            let dtos = try await httpClient.send(endpoint, as: [CategoryDTO].self)
            return dtos.map(Category.init(dto:))
        } catch let error as NetworkError {
            throw CatalogError.network(error)
        }
    }

    public func fetchProducts(query: ProductQuery) async throws -> ProductPage {
        var queryItems = [
            URLQueryItem(name: "select", value: Self.productSelect),
            // Over-fetch by one to determine `hasMore` without a second
            // round trip for a total count (see `ProductPage` doc comment).
            URLQueryItem(name: "limit", value: String(query.limit + 1)),
            URLQueryItem(name: "offset", value: String(query.offset)),
            URLQueryItem(name: "order", value: "name.asc")
        ]
        if let categoryID = query.categoryID {
            queryItems.append(URLQueryItem(name: "category_id", value: "eq.\(categoryID)"))
        }
        if let searchText = query.searchText, !searchText.isEmpty {
            let escaped = searchText.replacingOccurrences(of: ",", with: "")
            queryItems.append(URLQueryItem(name: "or", value: "(name.ilike.*\(escaped)*,description.ilike.*\(escaped)*)"))
        }

        do {
            let endpoint = Endpoint(path: "rest/v1/products", queryItems: queryItems)
            let dtos = try await httpClient.send(endpoint, as: [ProductDTO].self)
            let hasMore = dtos.count > query.limit
            let products = dtos.prefix(query.limit).map(Product.init(dto:))
            return ProductPage(items: Array(products), hasMore: hasMore)
        } catch let error as NetworkError {
            throw CatalogError.network(error)
        }
    }

    public func fetchProduct(id: String) async throws -> Product {
        do {
            let endpoint = Endpoint(
                path: "rest/v1/products",
                queryItems: [
                    URLQueryItem(name: "select", value: Self.productSelect),
                    URLQueryItem(name: "id", value: "eq.\(id)"),
                    URLQueryItem(name: "limit", value: "1")
                ],
                headers: ["Accept": "application/vnd.pgrst.object+json"]
            )
            let dto = try await httpClient.send(endpoint, as: ProductDTO.self)
            return Product(dto: dto)
        } catch NetworkError.notFound, NetworkError.server(406, _) {
            throw CatalogError.productNotFound
        } catch let error as NetworkError {
            throw CatalogError.network(error)
        }
    }

    // Caching is `OfflineCachingCatalogRepository`'s responsibility — see
    // `AuthenticationContainer`'s equivalent split for the reasoning
    // (composition over baking cross-cutting concerns into the network client).
    public func cachedCategories() -> [Category] { [] }
    public func cachedProduct(id: String) -> Product? { nil }
}
