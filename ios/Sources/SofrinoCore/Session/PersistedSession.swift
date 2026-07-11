import Foundation

/// The minimal, transport-level shape of an auth session — just enough for
/// `HTTPClient` to attach an `Authorization` header and for `SessionStore`
/// to persist/restore it. Feature modules (e.g. `SofrinoAuthentication`)
/// define their own richer domain models (`AuthUser`, `AuthSession`) and
/// map to/from this at their boundary, keeping `SofrinoCore` free of any
/// knowledge of roles, trade licenses, or other domain concepts.
public struct PersistedSession: Codable, Equatable, Sendable {
    public let userID: String
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date

    public init(userID: String, accessToken: String, refreshToken: String, expiresAt: Date) {
        self.userID = userID
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }

    public var isExpired: Bool {
        Date() >= expiresAt
    }
}
