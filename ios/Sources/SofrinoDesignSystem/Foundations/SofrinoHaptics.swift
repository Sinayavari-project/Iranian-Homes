import UIKit

/// Haptic vocabulary from the Sofrino Design System (Section 16: Haptics).
///
/// Centralizing haptics behind this enum means every call site uses the same
/// vocabulary ("confirm the order" rather than "fire a success notification
/// generator"), and generators are prepared once per invocation rather than
/// scattered across views.
@MainActor
public enum SofrinoHaptics {

    /// Light impact — button press, toggle, stepper increment, tab switch.
    public static func tap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    /// Selection feedback — picker scroll, segmented control switch, chart scrub.
    public static func select() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    /// Success notification — order placed, item added, payment confirmed.
    public static func confirm() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }

    /// Warning notification — approaching a limit, form validation issue.
    public static func warn() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }

    /// Error notification — request failed, payment declined.
    public static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }

    /// Heavy impact — long-press menu open, swipe action threshold crossed.
    public static func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }

    /// Rigid impact — drag-and-drop snap, sheet detent snap.
    public static func rigid() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        generator.impactOccurred()
    }
}
