import SwiftUI

/// Animation timing and spring presets from the Sofrino Design System
/// (Section 20: Animation Guidelines).
public enum SofrinoMotion {

    // MARK: Durations (for simple easing curves)

    public static let durationMicro: Double = 0.1
    public static let durationStandard: Double = 0.22
    public static let durationEmphasis: Double = 0.35
    public static let durationDramatic: Double = 0.65

    // MARK: Spring presets

    /// Snappy — button press, toggle.
    public static let springSnappy = Animation.spring(response: 0.25, dampingFraction: 0.9)
    /// Default — most UI transitions.
    public static let springDefault = Animation.spring(response: 0.35, dampingFraction: 0.85)
    /// Smooth — sheet presentation, section switch.
    public static let springSmooth = Animation.spring(response: 0.5, dampingFraction: 0.8)
    /// Bouncy — celebration moments, first-time delight.
    public static let springBouncy = Animation.spring(response: 0.5, dampingFraction: 0.65)

    /// Standard cross-fade used for tab switches and content swaps.
    public static let crossFade = Animation.easeInOut(duration: durationStandard)

    /// Returns the appropriate spring, respecting Reduce Motion by falling
    /// back to a simple cross-fade when the system setting is enabled.
    public static func spring(_ animation: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? crossFade : animation
    }

    /// Per-item delay for staggered list/grid entrance animations.
    /// Capped at 4 items (200ms) per the design system's stagger formula.
    public static func staggerDelay(index: Int) -> Double {
        Double(min(index, 4)) * 0.05
    }
}
