# Sofrino iOS Architecture

*Version 1.0 | July 2026*

This document explains how the Sofrino iOS codebase is organized, why it's organized that way, and how to wire the Swift Package into a real Xcode application target. It is the companion to `docs/sofrino-design-system.md` (visual language) and `docs/sofrino-home-screen.md` (the flagship screen spec) — this document covers code structure, not UI.

---

## Why a Swift Package, not just an Xcode project

The entire app — except the thin App target shell — lives in `ios/` as a Swift Package (`ios/Package.swift`) with four library products:

```
SofrinoDesignSystem   →  tokens + reusable components. Depends on nothing.
SofrinoCore           →  networking, persistence, session, DI. Depends on nothing.
SofrinoAuthentication →  the Authentication feature. Depends on Core + DesignSystem.
SofrinoApp            →  app shell (RootView, composition). Depends on all three.
```

This buys three things a single Xcode-project-with-groups setup doesn't:

1. **Enforced module boundaries.** `SofrinoAuthentication` cannot accidentally reach into a future `SofrinoCatalog` feature's internals — Swift's `import` model makes cross-feature coupling a compiler error, not a code-review nitpick.
2. **Fast, isolated builds and tests.** `swift test --filter SofrinoAuthenticationTests` builds only what that target depends on. As features grow, this keeps iteration fast.
3. **Xcode Previews that don't rebuild the world.** Editing a view in `SofrinoAuthentication` only recompiles that target and its dependencies, not a monolithic app target.

## Wiring this into an actual Xcode app

`swift build`/`swift test` build the library targets today (`SofrinoDesignSystem`, `SofrinoCore` compile on any platform with the Swift toolchain; `SofrinoAuthentication`/`SofrinoApp` require the iOS SDK because they import `SwiftUI`/`PhotosUI`, so they build under Xcode, not under Linux). To produce a runnable `.app`:

1. Create a new Xcode project: **iOS App**, SwiftUI lifecycle, name `Sofrino`, no Core Data, no tests (we already have a test plan below).
2. **File → Add Package Dependencies → Add Local...** and select `ios/` (the folder containing `Package.swift`). Link all four products to the `Sofrino` app target.
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

This repository is developed inside a Linux container without Xcode or an iOS SDK. `SwiftUI`, `PhotosUI`, and `UIKit` (used throughout `SofrinoDesignSystem` and `SofrinoAuthentication`) do not exist on Linux, so `swift build`/`swift test` for those targets will fail here with "no such module 'SwiftUI'" — that is expected, not a bug in the code. Every file in this package was written to compile under Xcode 16 on macOS with the iOS 17 SDK; verification (build, run, and the full test suite) must happen there. `SofrinoCore`'s pure-Foundation pieces (`NetworkError`, `Endpoint`, `OfflineRequestQueue`, DTO mapping logic) *do* build on Linux and are a reasonable smoke test in CI before a macOS runner takes over for the full suite.

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
- **Navigation lives in a coordinator, not in view models.** `AuthCoordinator.swift`'s `AuthFlowView` is the only file that knows the Authentication flow's screen order. Each view model exposes a callback (`onOTPRequested`, `onVerified`, `onRoleSelected`, `onSubmitted`) that the coordinator wires to a navigation action. A view model that pushed its own next screen would make screen order untestable and unreusable — the same `OTPVerificationViewModel` might one day be reachable from a "change phone number" settings flow with a completely different next screen, and it shouldn't need to know either destination.
- **One `<Feature>Container` per feature** (e.g. `AuthenticationContainer`) is the feature's composition root: it decides production vs. demo repository and hands out fully-wired view models. `AppContainer` (in `SofrinoCore`) holds only the handful of app-wide singletons every feature container needs (session, networking, reachability).

## The demo/production split (BRD §1, §11)

`AppEnvironment` (`SofrinoCore/Networking/AppEnvironment.swift`) is resolved once at launch from a scheme launch argument and never rechecked mid-session — an investor pitch should never have the app flicker between modes. Every feature container branches on it exactly once, at construction:

```
AuthenticationContainer.init(appContainer:)
  case .demo        → DemoAuthRepository (local fixtures, artificial latency, always succeeds)
  case .production  → SupabaseAuthRepository wrapped in OfflineQueuingAuthRepository
```

View models and views hold `any AuthRepository` and are completely unaware which one they got. This is the mechanism behind the BRD's demo-instability risk mitigation: "Demo routes use local fixtures only; never depend on network."

## Offline strategy

Three layers, each doing one job (Design System §2, principle 4 — "offline-aware, not offline-first"):

1. **`Reachability`** (`SofrinoCore/Networking/Reachability.swift`) wraps `NWPathMonitor` and lets `HTTPClient` fail fast into `.offline` instead of waiting out a 15-second timeout with no signal.
2. **`OfflineCache`** is a generic, namespaced disk cache for "show something instantly, refresh when possible" reads. Authentication doesn't use this heavily yet (there's little to cache before a user is signed in) — it's the same primitive future features like the home screen's Reorder Surface will use to show yesterday's order immediately while a fresh one loads.
3. **`OfflineRequestQueue<Operation>`** is for *writes* that must survive a dropped connection and an app relaunch. Authentication's one write with this shape is trade license submission (`OfflineQueuingAuthRepository` + `TradeLicenseUploadOperation`) — a supplier in a storeroom with one bar of signal can tap Submit, see it marked "queued," and trust it uploads the moment connectivity returns, without babysitting the screen.

## Testing strategy

- **`SofrinoCoreTests`** — pure logic, no UI: `NetworkError` classification, `OfflineRequestQueue` ordering/retry semantics, `SessionStore` persistence round-trips. These build and run on Linux today.
- **`SofrinoAuthenticationTests`** — view model behavior against `MockAuthRepository`, a fully scriptable test double (no networking, no Keychain, no real timers beyond the OTP resend countdown). Every view model's success path, failure path, and validation rules are covered.
- View-level (rendering, gesture, accessibility) testing is deliberately out of scope for unit tests and belongs in Xcode UI Tests / manual QA on-device, per the `/verify` workflow once this is running in Xcode.

## Design System integration

Every visual value in `SofrinoDesignSystem` (colors, type scale, spacing, radii, shadows, motion curves, haptics) is transcribed directly from `docs/sofrino-design-system.md`. If a designer changes a token in that document, the corresponding Swift file is the single place to update — `SofrinoColor.swift`, `SofrinoTypography.swift`, `SofrinoSpacing.swift`, `SofrinoShadow.swift`, `SofrinoMotion.swift`, `SofrinoHaptics.swift`, all under `Sources/SofrinoDesignSystem/Foundations/`. No feature module hardcodes a hex value, a point size, or a spring curve — everything routes through these tokens, which is what makes "every component reusable" (the Design System's closing contract) actually true in code, not just in the spec.
