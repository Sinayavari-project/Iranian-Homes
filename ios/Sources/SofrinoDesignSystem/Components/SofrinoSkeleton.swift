import SwiftUI

/// Shimmer skeleton block from the Sofrino Design System (Section 15: Skeletons).
///
/// A single primitive block with the design system's shimmer animation — a
/// 45-degree highlight sweeping across the block on an infinite 1.5s loop.
/// Every skeleton template in the app (product cards, list rows, order
/// cards) composes from this one primitive plus `SofrinoSkeletonCircle`.
public struct SofrinoSkeletonBlock: View {
    private let width: CGFloat?
    private let height: CGFloat
    private let cornerRadius: CGFloat

    @State private var phase: CGFloat = -1
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(width: CGFloat? = nil, height: CGFloat, cornerRadius: CGFloat = 4) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(SofrinoColor.Neutral.n150)
            .frame(width: width, height: height)
            .overlay(shimmerOverlay)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private var shimmerOverlay: some View {
        if reduceMotion {
            EmptyView()
        } else {
            GeometryReader { proxy in
                let sweepWidth = proxy.size.width * 0.4
                LinearGradient(
                    colors: [.clear, SofrinoColor.Neutral.n100, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: sweepWidth)
                .offset(x: (layoutDirection == .rightToLeft ? -1 : 1) * phase * (proxy.size.width + sweepWidth) - sweepWidth)
            }
        }
    }
}

/// Circular skeleton for avatars, icons, and thumbnails.
public struct SofrinoSkeletonCircle: View {
    private let diameter: CGFloat

    public init(diameter: CGFloat) {
        self.diameter = diameter
    }

    public var body: some View {
        SofrinoSkeletonBlock(width: diameter, height: diameter, cornerRadius: diameter / 2)
    }
}

#Preview("Skeleton Primitives") {
    VStack(alignment: .leading, spacing: 16) {
        HStack(spacing: 12) {
            SofrinoSkeletonCircle(diameter: 64)
            VStack(alignment: .leading, spacing: 6) {
                SofrinoSkeletonBlock(width: 160, height: 14)
                SofrinoSkeletonBlock(width: 100, height: 10)
            }
        }
        SofrinoSkeletonBlock(height: 180, cornerRadius: 12)
    }
    .padding()
}
