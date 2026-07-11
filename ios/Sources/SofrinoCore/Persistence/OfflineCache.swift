import Foundation

/// A generic, namespaced disk cache for `Codable` values.
///
/// This is the building block behind "offline-aware, not offline-first"
/// (Design System §2 principle 4): screens read the last-known cached
/// value immediately on load, then replace it once a fresh network response
/// arrives. Every feature module gets its own cache instance via a
/// `namespace`, so an `AuthenticationFeature` cache and a future
/// `CatalogFeature` cache never collide on disk.
public protocol OfflineCaching: Sendable {
    func save<T: Encodable>(_ value: T, forKey key: String) throws
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T?
    func remove(forKey key: String)
    func clear()
}

public final class OfflineCache: OfflineCaching {
    private let directory: URL
    private let fileManager: FileManager

    public init(namespace: String, fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.directory = caches.appendingPathComponent("com.sofrino.offlinecache/\(namespace)", isDirectory: true)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    public func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder.sofrinoDefault.encode(value)
        try data.write(to: fileURL(for: key), options: .atomic)
    }

    public func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = try? Data(contentsOf: fileURL(for: key)) else { return nil }
        return try? JSONDecoder.sofrinoDefault.decode(T.self, from: data)
    }

    public func remove(forKey key: String) {
        try? fileManager.removeItem(at: fileURL(for: key))
    }

    public func clear() {
        try? fileManager.removeItem(at: directory)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    private func fileURL(for key: String) -> URL {
        let safeKey = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        return directory.appendingPathComponent("\(safeKey).json")
    }
}
