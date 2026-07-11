import SofrinoDesignSystem

/// Shared arrow/sign/color formatting for a price-change percentage —
/// used by both `ProductListView`'s card badge (thresholded, so a 1-2%
/// wobble doesn't clutter a grid of thirty cards) and `ProductDetailView`'s
/// price row (shown for any nonzero change, since there's room and a buyer
/// looking at one product benefits from precision a grid doesn't need).
/// A cheaper price is good news for a buyer, so a drop renders as
/// `.success` (green) and an increase as `.error` (red) — the inverse of
/// how "red = bad" reads in most contexts, but consistent with the Home
/// Screen's Price Movements ticker (Home Screen §6).
func priceChangeBadge(forPercent percent: Int?, threshold: Int = 0) -> (text: String, style: SofrinoBadgeStyle)? {
    guard let percent, abs(percent) >= threshold, percent != 0 else { return nil }
    return percent < 0
        ? ("↓\(abs(percent))%", .success)
        : ("↑\(percent)%", .error)
}
