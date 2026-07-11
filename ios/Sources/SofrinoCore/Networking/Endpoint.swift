import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// A single HTTP request, described declaratively so `HTTPClient` can build,
/// execute, and log it uniformly. Repositories construct `Endpoint` values;
/// they never touch `URLRequest` directly.
public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let queryItems: [URLQueryItem]
    public let headers: [String: String]
    public let body: Data?
    /// If true, `HTTPClient` attaches the current session's bearer token.
    /// Auth endpoints (send OTP, verify OTP) set this to `false`.
    public let requiresAuth: Bool

    public init(
        path: String,
        method: HTTPMethod = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        requiresAuth: Bool = true
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.requiresAuth = requiresAuth
    }

    public static func jsonBody<T: Encodable>(_ value: T, encoder: JSONEncoder = .sofrinoDefault) throws -> Data {
        try encoder.encode(value)
    }
}

public extension JSONEncoder {
    static let sofrinoDefault: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}

public extension JSONDecoder {
    static let sofrinoDefault: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
