import Foundation

/// The single seam between the Authentication feature's view models and
/// the outside world. Two conformances exist: `SupabaseAuthRepository`
/// (production, talks to Supabase Auth over HTTPS) and `DemoAuthRepository`
/// (investor demo mode, always succeeds against local fixtures with
/// artificial-but-realistic latency). View models are constructed with
/// `any AuthRepository` and never know which one they're holding.
public protocol AuthRepository: Sendable {
    /// Requests an OTP be sent via SMS to a UAE mobile number in E.164
    /// format (e.g. "+971501234567").
    func requestOTP(phoneNumber: String) async throws -> Void

    /// Verifies the 6-digit code and returns a session. For a first-time
    /// phone number this creates the account; `AuthUser.role` will be `nil`
    /// until role selection completes.
    func verifyOTP(phoneNumber: String, code: String) async throws -> AuthSession

    /// Persists the user's chosen role. Restaurant buyers proceed straight
    /// to the home screen; suppliers are additionally routed to trade
    /// license upload before they can list products (BRD §8.1).
    func selectRole(_ role: UserRole, for userID: String) async throws -> AuthUser

    /// Uploads a trade license document and number for KYC review. Returns
    /// immediately with `kycStatus == .pending` — verification happens on
    /// the Admin console (BRD §5, §11).
    func submitTradeLicense(
        number: String,
        expiresAt: Date,
        documentData: Data,
        for userID: String
    ) async throws -> AuthUser

    /// Restores a previously authenticated session on app launch, if any.
    func restoreSession() async -> AuthSession?

    func signOut() async throws
}
