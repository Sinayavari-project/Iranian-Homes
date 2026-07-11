import Foundation
import Observation
import SofrinoCore

/// How this screen was entered — determines the title and whether the
/// search field is pre-focused. Both modes share the same paginated list
/// and the same `ProductQuery`, since a category browse and a search are
/// the same request shape with a different filter (Journey 3 in the
/// product vision: "browse or search, same ranked-results surface").
public enum ProductListContext: Hashable, Sendable {
    case category(id: String, name: String)
    case search(initialText: String)

    public var title: String {
        switch self {
        case .category(_, let name): return name
        case .search: return "Search"
        }
    }
}

@MainActor
@Observable
public final class ProductListViewModel {
    public let context: ProductListContext
    public private(set) var state: LoadState<[Product]> = .idle
    public private(set) var products: [Product] = []
    public private(set) var hasMore = false
    public private(set) var isLoadingMore = false
    public var isOffline: Bool = false

    public var searchText: String {
        didSet {
            guard searchText != oldValue else { return }
            scheduleSearch()
        }
    }

    public var onProductSelected: ((Product) -> Void)?

    private let repository: CatalogRepository
    private var currentQuery: ProductQuery
    private var searchDebounceTask: Task<Void, Never>?

    public init(context: ProductListContext, repository: CatalogRepository) {
        self.context = context
        self.repository = repository

        switch context {
        case .category(let id, _):
            self.searchText = ""
            self.currentQuery = ProductQuery(categoryID: id)
        case .search(let initialText):
            self.searchText = initialText
            self.currentQuery = ProductQuery(searchText: initialText.isEmpty ? nil : initialText)
        }
    }

    deinit {
        searchDebounceTask?.cancel()
    }

    public func loadFirstPage() async {
        currentQuery = currentQuery.firstPage()
        state = .loading
        do {
            let page = try await repository.fetchProducts(query: currentQuery)
            products = page.items
            hasMore = page.hasMore
            state = .loaded(products)
        } catch let error as CatalogError {
            state = .failed(error.userFacingMessage)
        } catch {
            state = .failed("Couldn't load products. Please try again.")
        }
    }

    /// Called by the view when a given product approaches the end of the
    /// visible list — the standard "load more near the bottom" trigger,
    /// rather than a separate "Load More" button (Design System §14).
    public func loadMoreIfNeeded(currentItem: Product) {
        guard hasMore, !isLoadingMore, !state.isLoading else { return }
        guard let index = products.firstIndex(where: { $0.id == currentItem.id }) else { return }
        let thresholdIndex = products.index(products.endIndex, offsetBy: -5, limitedBy: products.startIndex) ?? products.startIndex
        guard index >= thresholdIndex else { return }

        Task { await loadNextPage() }
    }

    private func loadNextPage() async {
        guard hasMore, !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }

        let nextQuery = currentQuery.nextPage()
        do {
            let page = try await repository.fetchProducts(query: nextQuery)
            currentQuery = nextQuery
            products.append(contentsOf: page.items)
            hasMore = page.hasMore
            state = .loaded(products)
        } catch {
            // A failed *next* page is silent — the list the user already
            // sees stays intact and scrollable; `hasMore` stays true so
            // scrolling back to the bottom retries automatically.
        }
    }

    public func selectProduct(_ product: Product) {
        onProductSelected?(product)
    }

    /// Fires on every `searchText` edit, in both contexts: typing while
    /// browsing a category refines within it (both filters combine in the
    /// same `ProductQuery`), typing in search mode searches everything.
    private func scheduleSearch() {
        searchDebounceTask?.cancel()
        searchDebounceTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(350))
            guard !Task.isCancelled, let self else { return }
            self.currentQuery.searchText = self.searchText.isEmpty ? nil : self.searchText
            await self.loadFirstPage()
        }
    }
}
