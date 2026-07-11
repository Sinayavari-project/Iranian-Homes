import SwiftUI

/// A horizontal shake — the standard Sofrino feedback for "that input was
/// rejected" (wrong OTP, invalid trade license number). Reusable across any
/// form field by giving it an `Equatable` trigger value; incrementing the
/// trigger replays the shake.
private struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = amount * sin(animatableData * .pi * CGFloat(shakesPerUnit))
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

public extension View {
    /// Shakes the view whenever `trigger` changes, unless Reduce Motion is
    /// enabled, in which case the shake is skipped entirely (the error
    /// state is still communicated via color/text — never via motion alone).
    func sofrinoShake(trigger: some Equatable) -> some View {
        modifier(SofrinoShakeModifier(trigger: trigger))
    }
}

private struct SofrinoShakeModifier<Trigger: Equatable>: ViewModifier {
    let trigger: Trigger
    @State private var animatableValue: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(animatableData: animatableValue))
            .onChange(of: trigger) { _, _ in
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 0.4)) {
                    animatableValue += 1
                }
            }
    }
}
