import Foundation

/// A normalized error surface for every network call in the app.
///
/// Repositories translate transport-level failures (`URLError`, decoding
/// failures, HTTP status codes) into this type so view models never need to
/// know whether a failure came from `URLSession`, `JSONDecoder`, or the
/// Supabase API itself.
public enum NetworkError: Error, Equatable, Sendable {
    case offline
    case timeout
    case unauthorized
    case notFound
    case rateLimited(retryAfterSeconds: Int?)
    case server(statusCode: Int, message: String?)
    case decoding(String)
    case invalidResponse
    case cancelled
    case unknown(String)

    /// A message safe to show directly to a restaurant buyer or supplier —
    /// no stack traces, no internal codes.
    public var userFacingMessage: String {
        switch self {
        case .offline:
            return "You're offline. We'll try again once you're back online."
        case .timeout:
            return "That took too long. Please try again."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .notFound:
            return "We couldn't find what you were looking for."
        case .rateLimited:
            return "Too many attempts. Please wait a moment and try again."
        case .server(_, let message):
            return message ?? "Something went wrong on our end. Please try again."
        case .decoding, .invalidResponse, .unknown:
            return "Something unexpected happened. Please try again."
        case .cancelled:
            return ""
        }
    }

    /// Whether retrying the exact same request is likely to succeed without
    /// user intervention — used by `OfflineRequestQueue` to decide what to
    /// re-queue versus surface immediately.
    public var isRetryable: Bool {
        switch self {
        case .offline, .timeout, .server:
            return true
        case .rateLimited:
            return true
        case .unauthorized, .notFound, .decoding, .invalidResponse, .cancelled, .unknown:
            return false
        }
    }
}
