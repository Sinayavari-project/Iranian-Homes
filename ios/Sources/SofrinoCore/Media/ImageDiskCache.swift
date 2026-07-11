import Foundation
import CryptoKit

/// Binary-data disk cache for downloaded images, keyed by URL. Distinct
/// from `OfflineCache` (which is `Codable`-oriented and namespaced per
/// feature) because image bytes are neither JSON nor tied to one feature —
/// a supplier logo fetched while browsing the catalog is the same file a
/// future Orders feature would fetch again for an order history row, and
/// both should hit the same cache entry.
public actor ImageDiskCache {
    public static let shared = ImageDiskCache()

    private let directory: URL
    private let fileManager: FileManager

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.directory = caches.appendingPathComponent("com.sofrino.imagecache", isDirectory: true)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    public func data(for url: URL) -> Data? {
        try? Data(contentsOf: fileURL(for: url))
    }

    public func store(_ data: Data, for url: URL) {
        try? data.write(to: fileURL(for: url), options: .atomic)
    }

    /// Evicts entries older than `maxAge` — called periodically rather than
    /// on every access, since image caches grow unboundedly otherwise
    /// (a chef scrolling a large catalog touches hundreds of product photos).
    public func evictEntries(olderThan maxAge: TimeInterval) {
        guard let contents = try? fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.contentModificationDateKey]
        ) else { return }

        let cutoff = Date().addingTimeInterval(-maxAge)
        for fileURL in contents {
            guard
                let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path),
                let modified = attributes[.modificationDate] as? Date,
                modified < cutoff
            else { continue }
            try? fileManager.removeItem(at: fileURL)
        }
    }

    private func fileURL(for url: URL) -> URL {
        let digest = SHA256.hash(data: Data(url.absoluteString.utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        return directory.appendingPathComponent(hex)
    }
}
