import Foundation
import Observation
import SofrinoCore

@MainActor
@Observable
public final class ProductDetailViewModel {
    public let productID: String
    public private(set) var state: LoadState<Product>

    private let repository: CatalogRepository

    public init(productID: String, repository: CatalogRepository) {
        self.productID = productID
        self.repository = repository
        if let cached = repository.cachedProduct(id: productID) {
            self.state = .loaded(cached)
        } else {
            self.state = .idle
        }
    }

    public func load() async {
        if state.value == nil {
            state = .loading
        }
        do {
            let product = try await repository.fetchProduct(id: productID)
            state = .loaded(product)
        } catch let error as CatalogError {
            state = failureOrStaleCache(message: error.userFacingMessage)
        } catch {
            state = failureOrStaleCache(message: "Couldn't load this product. Please try again.")
        }
    }

    private func failureOrStaleCache(message: String) -> LoadState<Product> {
        if let existing = state.value {
            return .loaded(existing)
        }
        return .failed(message)
    }
}
