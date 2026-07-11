import Foundation

// MARK: - Supabase Auth (/auth/v1/*) wire types
//
// These mirror Supabase's documented Auth REST API shapes exactly. They
// exist only inside `Data/` — nothing above the repository boundary ever
// sees a DTO; `SupabaseAuthRepository` maps every one of these to a
// `Domain` type before returning.

struct OTPRequestBody: Encodable {
    let phone: String
    /// Supabase creates the user on first OTP verification when this is
    /// true, which is the desired behavior for Sofrino's phone-first
    /// onboarding (BRD §8.1 — no separate "sign up" step exists).
    let createUser: Bool
}

struct OTPVerifyRequestBody: Encodable {
    let phone: String
    let token: String
    let type: String = "sms"
}

struct SupabaseAuthResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let user: SupabaseUserDTO
}

struct SupabaseUserDTO: Decodable {
    let id: String
    let phone: String?
    let createdAt: Date
}

// MARK: - PostgREST (/rest/v1/profiles) wire types
//
// The `profiles` table stores everything Supabase Auth doesn't: role,
// KYC status, and trade license fields. Per BRD §10 constraint, role is
// never read from a column on `profiles` for authorization decisions —
// that lives in a separate `user_roles` table guarded by `has_role()`.
// This `role` field is display/onboarding state only.

struct ProfileDTO: Codable {
    let id: String
    var displayName: String?
    var role: String?
    var kycStatus: String
    var tradeLicenseNumber: String?
    var tradeLicenseExpiresAt: Date?
    let createdAt: Date
}

struct ProfileUpsertBody: Encodable {
    let id: String
    var role: String?
    var kycStatus: String?
    var tradeLicenseNumber: String?
    var tradeLicenseExpiresAt: Date?
}

// MARK: - Domain mapping

extension AuthUser {
    init(profile: ProfileDTO, phoneNumber: String, createdAt: Date) {
        self.init(
            id: profile.id,
            phoneNumber: phoneNumber,
            displayName: profile.displayName,
            role: profile.role.flatMap(UserRole.init(rawValue:)),
            kycStatus: KYCStatus(rawValue: profile.kycStatus) ?? .notSubmitted,
            tradeLicenseNumber: profile.tradeLicenseNumber,
            tradeLicenseExpiresAt: profile.tradeLicenseExpiresAt,
            createdAt: createdAt
        )
    }
}
