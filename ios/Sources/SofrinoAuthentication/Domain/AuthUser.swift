import Foundation

/// KYC verification status for a user's trade license, per BRD §5 (Admin/Ops
/// role: "KYC, dispute resolution") and §10 constraint (trade-license
/// expiry tracking).
public enum KYCStatus: String, Codable, Sendable {
    case notSubmitted
    case pending
    case verified
    case rejected

    public var isActionable: Bool {
        self == .notSubmitted || self == .rejected
    }
}

/// The authenticated user, as understood by the client. Distinct from
/// `SofrinoCore.PersistedSession`, which is the transport-level session
/// shape — `AuthUser` is the domain-rich model the rest of the app (and
/// SwiftUI views) actually work with.
public struct AuthUser: Codable, Equatable, Identifiable, Sendable {
    public let id: String
    public let phoneNumber: String
    public var displayName: String?
    public var role: UserRole?
    public var kycStatus: KYCStatus
    public var tradeLicenseNumber: String?
    public var tradeLicenseExpiresAt: Date?
    public let createdAt: Date

    public init(
        id: String,
        phoneNumber: String,
        displayName: String? = nil,
        role: UserRole? = nil,
        kycStatus: KYCStatus = .notSubmitted,
        tradeLicenseNumber: String? = nil,
        tradeLicenseExpiresAt: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.displayName = displayName
        self.role = role
        self.kycStatus = kycStatus
        self.tradeLicenseNumber = tradeLicenseNumber
        self.tradeLicenseExpiresAt = tradeLicenseExpiresAt
        self.createdAt = createdAt
    }

    /// Whether onboarding is complete enough to enter the main app.
    /// A user can browse with `role == nil` for zero screens — role
    /// selection is mandatory before the home screen, per BRD §8.1.
    public var hasCompletedOnboarding: Bool {
        role != nil
    }
}

/// A domain-level auth session pairing the user with their access
/// credentials. View models depend on this, not on `PersistedSession`.
public struct AuthSession: Equatable, Sendable {
    public let user: AuthUser
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date

    public init(user: AuthUser, accessToken: String, refreshToken: String, expiresAt: Date) {
        self.user = user
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}
