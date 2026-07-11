import Foundation

/// The generic shape of "fetch something and show it" — as distinct from
/// the per-feature `SubmitState` enums used for mutation flows (see
/// `PhoneEntryViewModel.SubmitState` and siblings), which intentionally
/// stay feature-local because each mutation has its own specific failure
/// vocabulary. Reads don't: a category list, a product detail, a supplier
/// profile all reduce to the same four states, so this is the one place
/// that shape is defined.
///
/// `Value` is deliberately unconstrained — callers hold `LoadState<[Product]>`,
/// `LoadState<Product>`, `LoadState<[Category]>`, etc. Introduced with the
/// Catalog feature, the first read-heavy screen family in the app.
public enum LoadState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(String)

    public var value: Value? {
        if case .loaded(let value) = self { return value }
        return nil
    }

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    public var errorMessage: String? {
        if case .failed(let message) = self { return message }
        return nil
    }

    /// True once a first load attempt has resolved, success or failure —
    /// used to distinguish "haven't tried yet" (show nothing) from
    /// "tried and got nothing" (show an empty state).
    public var hasResolved: Bool {
        switch self {
        case .loaded, .failed: return true
        case .idle, .loading: return false
        }
    }
}

extension LoadState: Equatable where Value: Equatable {}
