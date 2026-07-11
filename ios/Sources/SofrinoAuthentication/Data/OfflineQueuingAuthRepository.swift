import Foundation
import SofrinoCore

/// Decorates any `AuthRepository` with offline-queued trade license
/// submission — the one Authentication mutation a supplier is likely to
/// make from a kitchen storeroom with poor signal (BRD §8.1 supplier
/// onboarding). Every other method passes straight through.
///
/// This is composition, not inheritance: `SupabaseAuthRepository` stays
/// entirely ignorant of offline concerns, and this decorator stays entirely
/// ignorant of Supabase's wire format. Either can be tested in isolation.
@MainActor
public final class OfflineQueuingAuthRepository: AuthRepository {
    private let inner: AuthRepository
    private let queue: OfflineRequestQueue<TradeLicenseUploadOperation>
    private let reachability: any ReachabilityMonitoring
    private let logger = SofrinoLogger(category: "auth-offline-queue")

    public init(inner: AuthRepository, cache: OfflineCaching, reachability: any ReachabilityMonitoring) {
        self.inner = inner
        self.reachability = reachability
        self.queue = OfflineRequestQueue(cache: cache) { operation in
            _ = try await inner.submitTradeLicense(
                number: operation.number,
                expiresAt: operation.expiresAt,
                documentData: operation.documentData,
                for: operation.userID
            )
        }
        reachability.onConnectivityChange { [weak self] isConnected in
            guard isConnected else { return }
            Task { await self?.queue.drain() }
        }
    }

    public func requestOTP(phoneNumber: String) async throws {
        try await inner.requestOTP(phoneNumber: phoneNumber)
    }

    public func verifyOTP(phoneNumber: String, code: String) async throws -> AuthSession {
        try await inner.verifyOTP(phoneNumber: phoneNumber, code: code)
    }

    public func selectRole(_ role: UserRole, for userID: String) async throws -> AuthUser {
        try await inner.selectRole(role, for: userID)
    }

    public func submitTradeLicense(
        number: String,
        expiresAt: Date,
        documentData: Data,
        for userID: String
    ) async throws -> AuthUser {
        guard reachability.isConnected else {
            logger.info("Offline — queuing trade license submission for retry")
            queue.enqueue(
                TradeLicenseUploadOperation(
                    id: UUID(),
                    createdAt: Date(),
                    userID: userID,
                    number: number,
                    expiresAt: expiresAt,
                    documentData: documentData
                )
            )
            // Optimistic result: the UI proceeds as though submission
            // succeeded, with status "pending" — exactly as it would if the
            // network call itself had succeeded. The queue reconciles the
            // real outcome silently once connectivity returns.
            return AuthUser(
                id: userID,
                phoneNumber: "",
                kycStatus: .pending,
                tradeLicenseNumber: number,
                tradeLicenseExpiresAt: expiresAt
            )
        }

        return try await inner.submitTradeLicense(
            number: number,
            expiresAt: expiresAt,
            documentData: documentData,
            for: userID
        )
    }

    public func restoreSession() async -> AuthSession? {
        await inner.restoreSession()
    }

    public func signOut() async throws {
        try await inner.signOut()
    }
}
