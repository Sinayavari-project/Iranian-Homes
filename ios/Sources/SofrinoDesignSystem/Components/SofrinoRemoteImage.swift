import SwiftUI
import SofrinoCore

/// The one way product photos, supplier logos, and category art load
/// anywhere in the app. Shows a shimmer skeleton while loading, a
/// cross-fade into the image on success (Design System §14 "skeleton →
/// content transition"), and a neutral fallback glyph on failure — a
/// product photo that fails to load should never leave a blank hole in a
/// grid.
public struct SofrinoRemoteImage: View {
    private let url: URL?
    private let contentMode: ContentMode
    private let cornerRadius: CGFloat

    @State private var phase: Phase = .loading
    private let loader: SofrinoImageLoader

    private enum Phase {
        case loading
        case loaded(Image)
        case failed
    }

    public init(
        url: URL?,
        contentMode: ContentMode = .fill,
        cornerRadius: CGFloat = 0,
        loader: SofrinoImageLoader = .shared
    ) {
        self.url = url
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.loader = loader
    }

    public var body: some View {
        ZStack {
            switch phase {
            case .loading:
                SofrinoSkeletonBlock(height: nil, cornerRadius: cornerRadius)
            case .loaded(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity.animation(SofrinoMotion.crossFade))
            case .failed:
                ZStack {
                    SofrinoColor.Neutral.n100
                    Image(systemName: "photo")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(SofrinoColor.Neutral.n300)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        guard let url else {
            phase = .failed
            return
        }
        phase = .loading
        do {
            let data = try await loader.data(for: url)
            guard let uiImage = UIImage(data: data) else {
                phase = .failed
                return
            }
            phase = .loaded(Image(uiImage: uiImage))
        } catch {
            phase = .failed
        }
    }
}
