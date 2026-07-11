# Sofrino iOS Architecture

*Version 1.0 | July 2026*

This document explains how the Sofrino iOS codebase is organized, why it's organized that way, and how to wire the Swift Package into a real Xcode application target. It is the companion to `docs/sofrino-design-system.md` (visual language) and `docs/sofrino-home-screen.md` (the flagship screen spec) — this document covers code structure, not UI.

---

## Why a Swift Package, not just an Xcode project

The entire app — except the thin App target shell — lives in `ios/` as a Swift Package (`ios/Package.swift`) with five library products:

```
SofrinoCore           →  networking, persistence, session, media, DI. Depends on nothing.
SofrinoDesignSystem   →  tokens + reusable components. Depends on Core (see below).
SofrinoAuthentication →  the Authentication feature. Depends on Core + DesignSystem.
SofrinoCatalog        →  the Product Catalog feature. Depends on Core + DesignSystem.
SofrinoApp            →  app shell (RootView, composition). Depends on all four.
```

### Why DesignSystem now depends on Core

This is a change from the Authentication-only version of this document, made while building the Catalog feature and worth explaining rather than silently editing. `SofrinoDesignSystem` originally depended on nothing. Catalog is the first feature that needed to display remote images at scale (product photos, supplier logos, category art) with real caching — a shimmer placeholder, a disk+memory cache, request de-duplication so six grid cells showing the same supplier logo don't trigger six downloads. That's not a design token; it's a small networking/caching subsystem (`SofrinoCore/Media/SofrinoImageLoader.swift` + `ImageDiskCache.swift`), and it belongs in `SofrinoCore` for the same reason `HTTPClient` does — feature modules shouldn't each reinvent it.

The reusable component that *uses* that loader (`SofrinoRemoteImage`) belongs in `SofrinoDesignSystem`, because that's where every other reusable visual component lives and where `SofrinoProductCard` — which embeds a `SofrinoRemoteImage` — already is. Rather than duplicate a headless loader inside DesignSystem (fighting the "one networking stack" rule) or move a SwiftUI `View` into Core (blurring Core's "no UI" boundary far more than this does), `SofrinoDesignSystem` takes a dependency on `SofrinoCore`. The graph stays an acyclic DAG — Core still depends on nothing — so this doesn't introduce a cycle, and every feature module's existing `[Core, DesignSystem]` dependency list is unaffected.

This buys three things a single Xcode-project-with-groups setup doesn't:

1. **Enforced module boundaries.** `SofrinoAuthentication` cannot accidentally reach into a future `SofrinoCatalog` feature's internals — Swift's `import` model makes cross-feature coupling a compiler error, not a code-review nitpick.
2. **Fast, isolated builds and tests.** `swift test --filter SofrinoAuthenticationTests` builds only what that target depends on. As features grow, this keeps iteration fast.
3. **Xcode Previews that don't rebuild the world.** Editing a view in `SofrinoAuthentication` only recompiles that target and its dependencies, not a monolithic app target.

## Wiring this into an actual Xcode app

`swift build`/`swift test` build the library targets today (`SofrinoDesignSystem`, `SofrinoCore` compile on any platform with the Swift toolchain; `SofrinoAuthentication`/`SofrinoApp` require the iOS SDK because they import `SwiftUI`/`PhotosUI`, so they build under Xcode, not under Linux). To produce a runnable `.app`:

1. Create a new Xcode project: **iOS App**, SwiftUI lifecycle, name `Sofrino`, no Core Data, no tests (we already have a test plan below).
2. **File → Add Package Dependencies → Add Local...** and select `ios/` (the folder containing `Package.swift`). Link all five products to the `Sofrino` app target.
3. Delete the auto-generated `ContentView.swift` and the `@main` App struct Xcode generated.
4. Add one new file directly in the Xcode app target (not the package) — `Sofrino/SofrinoiOSApp.swift`:

   ```swift
   import SwiftUI
   import SofrinoApp

   @main
   struct SofrinoiOSApp: App {
       var body: some Scene {
           SofrinoAppRoot().body
       }
   }
   ```

   This file must live in the app target because `@main` requires an executable target, and Swift Packages can't produce iOS `.app` executables directly — everything else stays in the package.
5. Add `Config/Supabase.xcconfig` (git-ignored — never commit real keys) with:
   ```
   SOFRINO_SUPABASE_URL = https://your-project.supabase.co
   SOFRINO_SUPABASE_ANON_KEY = your-anon-key
   ```
   Reference both keys from the target's Info.plist as `SOFRINO_SUPABASE_URL` / `SOFRINO_SUPABASE_ANON_KEY` (`$(SOFRINO_SUPABASE_URL)` build setting substitution). `AppEnvironment.fromInfoPlist()` in `SofrinoCore/Networking/AppEnvironment.swift` reads these at launch.
6. Add a second scheme, **Sofrino-Demo**, with launch argument `-SofrinoDemoMode YES` — this is what `AppEnvironment.resolve()` checks to route into `DemoAuthRepository` instead of the real network, per BRD §1's "investor-ready demo environment that always works perfectly."
7. Minimum deployment target: **iOS 17.0** (see `Package.swift` platforms and the Design System's tech stack rationale — `@Observable`, modern `NavigationStack`, `PhotosPicker`, and String Catalogs all assume iOS 17).

## Why this environment can't build or run the app

This repository is developed inside a Linux container without Xcode or an iOS SDK. `SwiftUI`, `PhotosUI`, and `UIKit` (used throughout `SofrinoDesignSystem`, `SofrinoAuthentication`, and `SofrinoCatalog`) do not exist on Linux, so `swift build`/`swift test` for those targets will fail here with "no such module 'SwiftUI'" — that is expected, not a bug in the code. Every file in this package was written to compile under Xcode 16 on macOS with the iOS 17 SDK; verification (build, run, and the full test suite) must happen there. `SofrinoCore`'s pure-Foundation pieces (`NetworkError`, `Endpoint`, `OfflineRequestQueue`, `LoadState`, `Money`, DTO mapping logic) *do* build on Linux and are a reasonable smoke test in CI before a macOS runner takes over for the full suite. (`SofrinoImageLoader`/`ImageDiskCache` are the exception within Core — they're pure Foundation too, but exist only to back a SwiftUI view, so they're only exercised once the rest of the graph builds under Xcode.)

## MVVM, precisely

Every screen has exactly three files:

```
Presentation/<Feature>/
  <Feature>ViewModel.swift   — @Observable, @MainActor. Owns UI state and calls the repository.
  <Feature>View.swift        — SwiftUI View. Reads the view model, renders Design System components.
```

Rules that keep this consistent as the app grows:

- **View models never import SwiftUI's `View` protocol conformances** — they're plain `@Observable` classes. This is what makes them unit-testable without a simulator (see `Tests/SofrinoAuthenticationTests/PhoneEntryViewModelTests.swift` — every test runs in milliseconds, no UI host required).
- **Views never call a repository directly.** If a view needs data, it asks its view model. This is the one rule that, if broken, silently turns MVVM into MV.
- **Navigation lives in a coordinator, not in view models.** `AuthCoordinator.swift`'s `AuthFlowView` (Authentication) and `CatalogCoordinator.swift`'s `CatalogFlowView` (Catalog) are each the only file that knows their feature's screen order. Each view model exposes a callback (`onOTPRequested`, `onVerified`, `onCategorySelected`, `onProductSelected`, ...) that the coordinator wires to a navigation action. A view model that pushed its own next screen would make screen order untestable and unreusable — `ProductListViewModel` is reachable two ways (browse a category, or search) and shouldn't need to know which one led to it or what a tapped product pushes next.
- **One `<Feature>Container` per feature** (e.g. `AuthenticationContainer`, `CatalogContainer`) is the feature's composition root: it decides production vs. demo repository and hands out fully-wired view models. `AppContainer` (in `SofrinoCore`) holds only the handful of app-wide singletons every feature container needs (session, networking, reachability).
- **Cross-feature UI seams stay generic.** `RootView` needs *something* to happen when the Catalog root screen's profile icon is tapped, but Catalog itself has no concept of "signing out" — that's an Authentication concern. `CategoryListViewModel.onAccountTapped` is a plain `(() -> Void)?` the app shell supplies; Catalog only knows "the account affordance was tapped," never why. The alternative — Catalog importing `SofrinoAuthentication` to call `signOut()` directly — would make two sibling features depend on each other for no reason tied to either one's actual job.

## The demo/production split (BRD §1, §11)

`AppEnvironment` (`SofrinoCore/Networking/AppEnvironment.swift`) is resolved once at launch from a scheme launch argument and never rechecked mid-session — an investor pitch should never have the app flicker between modes. Every feature container branches on it exactly once, at construction:

```
AuthenticationContainer.init(appContainer:)
  case .demo        → DemoAuthRepository (local fixtures, artificial latency, always succeeds)
  case .production  → SupabaseAuthRepository wrapped in OfflineQueuingAuthRepository
```

View models and views hold `any AuthRepository` and are completely unaware which one they got. This is the mechanism behind the BRD's demo-instability risk mitigation: "Demo routes use local fixtures only; never depend on network."

## Offline strategy

Four layers now, each doing one job (Design System §2, principle 4 — "offline-aware, not offline-first"):

1. **`Reachability`** (`SofrinoCore/Networking/Reachability.swift`) wraps `NWPathMonitor` and lets `HTTPClient` fail fast into `.offline` instead of waiting out a 15-second timeout with no signal.
2. **`OfflineCache`** is a generic, namespaced disk cache for "show something instantly, refresh when possible" reads.
3. **`OfflineRequestQueue<Operation>`** is for *writes* that must survive a dropped connection and an app relaunch. Authentication's one write with this shape is trade license submission (`OfflineQueuingAuthRepository` + `TradeLicenseUploadOperation`) — a supplier in a storeroom with one bar of signal can tap Submit, see it marked "queued," and trust it uploads the moment connectivity returns, without babysitting the screen.
4. **Cache-then-network reads**, new with Catalog: `OfflineCachingCatalogRepository` wraps categories and individual product fetches so `CategoryListViewModel`/`ProductDetailViewModel` can call `repository.cachedCategories()` / `cachedProduct(id:)` synchronously in `init` and paint instantly, then call the `async throws` fetch to get a fresh copy — falling back to the still-visible cached value rather than blanking the screen if that fetch fails (`CategoryListViewModel.failureOrStaleCache(message:)`). This is a *different* shape from `OfflineRequestQueue`: queuing replays a write once connectivity returns; this decorator just serves the last-known-good read immediately and lets a background refresh replace it. Paginated product *lists* are deliberately excluded from this — see `docs/sofrino-catalog-feature.md` for why live data matters more than instant paint there.

Both offline-write and offline-read decorators follow the same shape: wrap `any FooRepository` in another `FooRepository` conformance that adds exactly one cross-cutting concern, so `SupabaseCatalogRepository`/`SupabaseAuthRepository` stay entirely ignorant of caching or queuing, and that concern is unit-testable in isolation (`OfflineQueuingAuthRepositoryTests`, `OfflineCachingCatalogRepositoryTests`).

## Testing strategy

- **`SofrinoCoreTests`** — pure logic, no UI: `NetworkError` classification, `OfflineRequestQueue` ordering/retry semantics, `SessionStore` persistence round-trips, `Money` arithmetic/formatting/rounding, `LoadState` accessors. These build and run on Linux today.
- **`SofrinoAuthenticationTests`** — view model behavior against `MockAuthRepository`, a fully scriptable test double (no networking, no Keychain, no real timers beyond the OTP resend countdown). Every view model's success path, failure path, and validation rules are covered.
- **`SofrinoCatalogTests`** — same pattern against `MockCatalogRepository`: cache-then-network fallback behavior for categories and product detail, pagination (`loadMoreIfNeeded`'s near-the-end trigger, the "fetch limit+1 to derive `hasMore`" contract), and the search debounce timing in `ProductListViewModel`.
- View-level (rendering, gesture, accessibility) testing is deliberately out of scope for unit tests and belongs in Xcode UI Tests / manual QA on-device, per the `/verify` workflow once this is running in Xcode.

## Shared utilities (`SofrinoCore/Utilities`)

Two small types introduced with Catalog, worth calling out because every future feature should reach for them rather than reinventing their shape:

- **`LoadState<Value>`** is the generic "fetch something and show it" state — `.idle` / `.loading` / `.loaded(Value)` / `.failed(String)` — for read-heavy screens. It's deliberately *not* used for mutation flows (`PhoneEntryViewModel.SubmitState` and siblings stay feature-local enums), because a mutation's failure vocabulary is specific to that mutation in a way "fetch and display" never is. Use `LoadState` for anything that's fundamentally "GET this, render it": category lists, product detail, and every future read screen (order history, supplier profiles, analytics).
- **`Money`** is a `Decimal`-backed AED amount — never `Double` for a price, ever. See the type's doc comment and `MoneyTests` for the concrete float-rounding failure this avoids. Every feature that touches a price (Catalog today; Cart, Checkout, BNPL, Orders later) should hold `Money`, not `Decimal` or `Double` directly, so formatting (`"AED 32.50"`) and arithmetic (summing a cart, computing a percentage price change) stay in one place.

## Design System integration

Every visual value in `SofrinoDesignSystem` (colors, type scale, spacing, radii, shadows, motion curves, haptics) is transcribed directly from `docs/sofrino-design-system.md`. If a designer changes a token in that document, the corresponding Swift file is the single place to update — `SofrinoColor.swift`, `SofrinoTypography.swift`, `SofrinoSpacing.swift`, `SofrinoShadow.swift`, `SofrinoMotion.swift`, `SofrinoHaptics.swift`, all under `Sources/SofrinoDesignSystem/Foundations/`. No feature module hardcodes a hex value, a point size, or a spring curve — everything routes through these tokens, which is what makes "every component reusable" (the Design System's closing contract) actually true in code, not just in the spec.

Components are added to `SofrinoDesignSystem/Components/` the first time a feature actually needs them, not speculatively ahead of need — `SofrinoOTPField` arrived with Authentication; `SofrinoBadge`, `SofrinoEmptyState`, `SofrinoSearchField`, `SofrinoCategoryTile`, `SofrinoProductCard`, and `SofrinoRemoteImage` arrived with Catalog, each implementing a section of `docs/sofrino-design-system.md` (§7, §9, §12, §13) that had no code yet. The design system also specs a list-layout product row (§7 "Product Card (List)"); it isn't built yet because nothing in the app displays products in a vertical list — Catalog uses the grid layout throughout. Build it when a feature (order history line items, a Cart list) actually needs it, following the same primitive-parameters contract as `SofrinoProductCard`.

One rule enforces reusability at the type-signature level, not just by convention: **components take primitive display values, never a feature's domain model.** `SofrinoProductCard` takes `imageURL: URL?`, `name: String`, `priceText: String`, etc. — not a `SofrinoCatalog.Product`. If it took `Product` directly, `SofrinoDesignSystem` would need to depend on `SofrinoCatalog`, which would make the component *un*-reusable by definition (a future Cart or Orders feature wanting the same card would either duplicate it or take on a Catalog dependency it doesn't need). Each feature maps its own model to the primitive parameters at the call site instead (see `ProductListView.badge(for:)` for the mapping logic).
