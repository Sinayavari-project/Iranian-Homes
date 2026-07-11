# Sofrino Product Catalog Feature

*Version 1.0 | July 2026*

The second feature built on the Sofrino iOS architecture, after Authentication. This document covers what it does, the architecture decisions specific to it, and what's deliberately left for later features to build.

---

## Flow

```
CategoryListView (root, inside the authenticated app shell)
      │
      ├── tap a category tile ────────► ProductListView (context: .category)
      │                                        │
      ├── submit the search field ────► ProductListView (context: .search)
      │                                        │
      │                                        │ tap a product
      │                                        ▼
      │                                 ProductDetailView
      │
      └── tap the profile icon ───────► (app shell decides — today, sign out)
```

`CategoryListView` is reached directly from `RootView` once `SessionStore.isAuthenticated` is true — it is the Catalog feature's entry point into the authenticated app shell, standing in for the not-yet-built Home Screen (`docs/sofrino-home-screen.md`) the same way Authentication's screens are the only thing behind the sign-in wall today.

## Why category browse and search share one screen

Both a category tap and a search submission land on `ProductListView`, parameterized by a `ProductListContext` (`.category(id:name:)` or `.search(initialText:)`). They're the same request shape — a filtered, paginated `ProductQuery` — with a different filter populated, and the product vision's Journey 3 ("Supplier Discovery") describes them as the same ranked-results surface either way. Building two separate screens would mean building pagination, the empty-state logic, and the grid layout twice.

The search field stays visible even in category context, and typing in it *also* filters within the category (`ProductListViewModel.scheduleSearch()` updates `currentQuery.searchText` without clearing `categoryID`) — both filters apply together in `SupabaseCatalogRepository.fetchProducts`, since PostgREST combines separate query parameters with an implicit AND.

## Pagination without exposing response headers

Supabase's PostgREST API reports total row counts via a `Content-Range` response header when you ask for it with `Prefer: count=exact`. `HTTPClientProtocol` doesn't expose response headers to callers — it decodes straight to a domain type — and extending that contract for one caller would widen an interface every other repository would inherit for no benefit.

Instead, `SupabaseCatalogRepository.fetchProducts` requests `limit + 1` rows. If it gets back `limit + 1`, there's more; it trims the extra row before returning. `DemoCatalogRepository` does the equivalent with a plain array slice. `ProductPage.hasMore` is derived this way in both repositories, so `ProductListViewModel` never needs to know which one it's talking to.

`ProductListViewModel.loadMoreIfNeeded(currentItem:)` is called from `ProductListView`'s `.onAppear` on every rendered card — not a "Load More" button — and fires the next page once the visible item is within 5 of the end of the currently-loaded list (Design System §14's "load more near the bottom" convention). A failed *next* page fails silently: the list the user already has stays intact and scrollable, and `hasMore` stays `true` so scrolling back down retries automatically next time a card near the end appears.

## What's cached and what isn't

`OfflineCachingCatalogRepository` caches **categories** and **individual product detail** — both small, stable-shaped data worth painting instantly from a previous session. It deliberately does **not** cache paginated product *lists* (browse or search results): those need to reflect current price and current stock, and a restaurant buyer comparing prices on stale cached data would be actively misled rather than merely inconvenienced. A failed list fetch surfaces as a retryable error (`SofrinoEmptyState` with a Retry button) instead of silently serving old numbers.

`CategoryListViewModel` and `ProductDetailViewModel` both read `repository.cachedCategories()` / `cachedProduct(id:)` synchronously in `init`, painting the screen before the first `await` resolves. If the subsequent network fetch fails, `failureOrStaleCache(message:)` keeps whatever's already on screen rather than replacing it with an error — the categories a chef is already looking at don't need to vanish because one refresh attempt failed.

## Two repositories, one contract

Same shape as Authentication: `CatalogRepository` has `SupabaseCatalogRepository` (production, direct PostgREST calls, no SDK — same rationale as `SupabaseAuthRepository`) and `DemoCatalogRepository` (an `actor` holding realistic UAE fixtures — supplier and product names match the ones used as worked examples throughout `docs/sofrino-home-screen.md`, so a demo walkthrough feels internally consistent with the specs rather than showing placeholder data). `CatalogContainer` picks one based on `AppEnvironment`, exactly like `AuthenticationContainer`.

## Money, not Double

`Product.price` and `Product.previousPrice` are `SofrinoCore.Money`, a `Decimal`-backed type added while building this feature (see `docs/sofrino-ios-architecture.md`, "Shared utilities"). `Product.priceChangePercent` — what drives the price-drop/price-increase badge on both the product card and the detail screen — is computed via `Money.percentageChange(to:)`, rounded to the nearest whole percent rather than truncated, so a genuine 16.9% increase reads as "17%," not an understated "16%."

## What's intentionally not in this feature yet

- **No Add to Cart.** `SofrinoProductCard`'s quick-add button and quantity stepper exist in the Design System component (`onAdd: (() -> Void)?`), but Catalog passes `nil` — there's no Cart feature yet to wire it to. Wiring a button to nothing would be exactly the "half-finished implementation" this codebase avoids; the button simply doesn't render until Cart exists to give it something to do.
- **No product comparison.** The product vision's Journey 3 describes comparing 2-3 suppliers for the same item side-by-side. This screen supports discovering and filtering products, not comparing specific ones head-to-head — that's a distinct, more complex interaction (a comparison table or sheet) that deserves its own design pass rather than being bolted onto the list.
- **No reviews.** `Product.rating` / `reviewCount` are displayed, but there's no reviews *list* screen — that's part of BRD §8.1's "reviews" scope for the Restaurant section, not Catalog specifically.
- **Supplier profile is a summary, not a screen.** Tapping a supplier's name on the product detail screen currently does nothing — `SupplierSummary` has just enough fields (name, verified, rating, delivery estimate) to render inline; a full tappable supplier profile (Home Screen §9 "The Deck") is its own feature.

## Testing

`Tests/SofrinoCatalogTests/` covers: `CategoryListViewModel`'s cache-then-network sequencing (starts loaded from cache when available, keeps stale cache visible on a failed refresh, surfaces an error only when there's no cache to fall back to); `ProductListViewModel`'s context-to-query mapping, pagination trigger threshold, and search debounce timing; `ProductDetailViewModel`'s equivalent cache-then-network behavior; and `OfflineCachingCatalogRepository` directly (cache population, stale-cache-on-failure, and confirming product *lists* pass through without being cached). `Tests/SofrinoCoreTests/MoneyTests.swift` covers the `Decimal`-vs-`Double` correctness case directly (`0.1 + 0.2` must equal exactly `0.3`) and the percentage-rounding behavior the price-change badges depend on.
