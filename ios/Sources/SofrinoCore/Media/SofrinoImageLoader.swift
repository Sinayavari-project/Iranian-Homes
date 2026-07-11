import Foundation

/// Downloads and caches image bytes for `SofrinoRemoteImage`
/// (`SofrinoDesignSystem`). Three layers, checked in order: an in-memory
/// `NSCache` for images already decoded this session, `ImageDiskCache` for
/// images downloaded in a previous session, and the network as the last
/// resort.
///
/// Sofrino intentionally does not adopt a third-party image library
/// (Nuke, Kingfisher) here — the same reasoning as `SupabaseHTTPClient`
/// avoiding the Supabase SDK: the full request/cache/decode pipeline for a
/// single `Data` fetch is small enough that owning it directly keeps the
/// dependency graph minimal and every step inspectable, and it reuses the
/// same `URLSession` already configured for the rest of the app.
public actor SofrinoImageLoader {
    public static let shared = SofrinoImageLoader()

    private let session: URLSession
    private let diskCache: ImageDiskCache
    private let memoryCache = NSCache<NSURL, NSData>()
    /// Coalesces concurrent requests for the same URL — a product grid
    /// with the same supplier logo in six cells should trigger one
    /// download, not six.
    private var inFlightTasks: [URL: Task<Data, Error>] = [:]

    public init(session: URLSession = .shared, diskCache: ImageDiskCache = .shared) {
        self.session = session
        self.diskCache = diskCache
        memoryCache.countLimit = 200
        memoryCache.totalCostLimit = 100 * 1024 * 1024 // 100 MB of decoded bytes
    }

    public func data(for url: URL) async throws -> Data {
        if let cached = memoryCache.object(forKey: url as NSURL) {
            return cached as Data
        }

        if let existing = inFlightTasks[url] {
            return try await existing.value
        }

        let task = Task<Data, Error> { [diskCache, session] in
            if let onDisk = await diskCache.data(for: url) {
                return onDisk
            }
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse, 200...299 ~= http.statusCode else {
                throw NetworkError.invalidResponse
            }
            await diskCache.store(data, for: url)
            return data
        }
        inFlightTasks[url] = task

        do {
            let data = try await task.value
            memoryCache.setObject(data as NSData, forKey: url as NSURL, cost: data.count)
            inFlightTasks[url] = nil
            return data
        } catch {
            inFlightTasks[url] = nil
            throw error
        }
    }
}
