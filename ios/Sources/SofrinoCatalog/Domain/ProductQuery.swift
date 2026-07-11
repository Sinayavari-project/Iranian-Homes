import Foundation

/// Describes one page of the product list — either "browse this category"
/// or "search across everything," never both, mirroring the two entry
/// points into `ProductListView` (Journey 3 in the product vision: browse
/// or search, same ranked-results surface either way).
public struct ProductQuery: Equatable, Sendable {
    public var categoryID: String?
    public var searchText: String?
    public var offset: Int
    public var limit: Int

    public init(categoryID: String? = nil, searchText: String? = nil, offset: Int = 0, limit: Int = 20) {
        self.categoryID = categoryID
        self.searchText = searchText
        self.offset = offset
        self.limit = limit
    }

    /// The same query, advanced to the next page — used by
    /// `ProductListViewModel` when the user scrolls near the end of the list.
    public func nextPage() -> ProductQuery {
        var next = self
        next.offset += limit
        return next
    }

    /// The same query, reset to the first page — used on pull-to-refresh
    /// and whenever the search text or category changes.
    public func firstPage() -> ProductQuery {
        var first = self
        first.offset = 0
        return first
    }
}

/// One page of results plus whether another page exists — `hasMore` is
/// derived by the repository from an over-fetch (see
/// `SupabaseCatalogRepository`), not from a total count, so it costs
/// nothing extra to compute.
public struct ProductPage: Equatable, Sendable {
    public let items: [Product]
    public let hasMore: Bool

    public init(items: [Product], hasMore: Bool) {
        self.items = items
        self.hasMore = hasMore
    }

    public static let empty = ProductPage(items: [], hasMore: false)
}
