import Foundation
import Observation
import SofrinoCore

@MainActor
@Observable
public final class CategoryListViewModel {
    public private(set) var state: LoadState<[Category]> = .idle
    public var searchText: String = ""
    public var isOffline: Bool = false

    /// Fired when the user taps a category tile — the coordinator pushes
    /// `ProductListView` scoped to that category.
    public var onCategorySelected: ((Category) -> Void)?
    /// Fired when the user submits the search field — the coordinator
    /// pushes `ProductListView` in search mode instead.
    public var onSearchSubmitted: ((String) -> Void)?
    /// Fired when the profile avatar in the nav bar is tapped (Home Screen
    /// §1 "Navigation Chrome"). There's no Account feature yet, so the app
    /// shell wires this to whatever it needs — today, sign-out — rather
    /// than Catalog knowing anything about accounts or auth.
    public var onAccountTapped: (() -> Void)?

    private let repository: CatalogRepository

    public init(repository: CatalogRepository) {
        self.repository = repository
        // Instant paint from cache (or, in demo mode, from the always-warm
        // seed data) before the network round trip resolves — Design
        // System §2 principle 4.
        let cached = repository.cachedCategories()
        if !cached.isEmpty {
            state = .loaded(cached)
        }
    }

    public func load() async {
        if state.value == nil {
            state = .loading
        }
        do {
            let categories = try await repository.fetchCategories()
            state = .loaded(categories)
        } catch let error as CatalogError {
            state = failureOrStaleCache(message: error.userFacingMessage)
        } catch {
            state = failureOrStaleCache(message: "Couldn't load categories. Please try again.")
        }
    }

    public func submitSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onSearchSubmitted?(trimmed)
    }

    public func selectCategory(_ category: Category) {
        onCategorySelected?(category)
    }

    /// A failed refresh shouldn't blank out categories the user is already
    /// looking at from cache — only surface the error if there's nothing
    /// on screen to fall back to.
    private func failureOrStaleCache(message: String) -> LoadState<[Category]> {
        if let existing = state.value, !existing.isEmpty {
            return .loaded(existing)
        }
        return .failed(message)
    }
}
