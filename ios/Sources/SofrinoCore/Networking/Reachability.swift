import Foundation
import Network

/// Wraps `NWPathMonitor` behind a small, testable interface. Repositories
/// and `HTTPClient` consult `isConnected` before attempting a network call
/// so the app can fail fast into offline handling rather than waiting out a
/// full URLSession timeout on every request while the device has no signal.
@MainActor
public protocol ReachabilityMonitoring: AnyObject, Sendable {
    var isConnected: Bool { get }
    /// Invoked whenever connectivity flips. Used by `OfflineRequestQueue`
    /// to know when to attempt draining queued mutations.
    func onConnectivityChange(_ handler: @escaping (Bool) -> Void)
}

@MainActor
public final class Reachability: ReachabilityMonitoring {
    public static let shared = Reachability()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.sofrino.reachability")
    private var handlers: [(Bool) -> Void] = []

    public private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            Task { @MainActor in
                self?.update(isConnected: connected)
            }
        }
        monitor.start(queue: queue)
    }

    private func update(isConnected: Bool) {
        guard self.isConnected != isConnected else { return }
        self.isConnected = isConnected
        handlers.forEach { $0(isConnected) }
    }

    public func onConnectivityChange(_ handler: @escaping (Bool) -> Void) {
        handlers.append(handler)
    }
}
