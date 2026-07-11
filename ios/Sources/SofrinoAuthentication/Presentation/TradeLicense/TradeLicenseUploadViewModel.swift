import Foundation
import Observation
import SofrinoCore
import SofrinoDesignSystem

@MainActor
@Observable
public final class TradeLicenseUploadViewModel {
    public enum SubmitState: Equatable {
        case idle
        case submitting
        case queuedOffline
        case failed(String)
    }

    public var licenseNumber: String = "" {
        didSet { if case .failed = submitState { submitState = .idle } }
    }
    public var expiryDate: Date = Calendar.current.date(byAdding: .year, value: 1, to: .now) ?? .now
    public var documentData: Data?
    public private(set) var submitState: SubmitState = .idle
    public var isOffline: Bool = false

    /// Fired once the license has either been submitted for review or
    /// queued for offline retry — both are treated as forward progress by
    /// the coordinator (BRD's "offline-aware, not offline-first" principle
    /// means the supplier isn't blocked from proceeding into the app).
    public var onSubmitted: ((AuthUser) -> Void)?

    private let userID: String
    private let repository: AuthRepository

    public init(userID: String, repository: AuthRepository) {
        self.userID = userID
        self.repository = repository
    }

    public var isNumberValid: Bool {
        licenseNumber.count == 6 && licenseNumber.allSatisfy(\.isNumber)
    }

    public var isExpiryValid: Bool {
        expiryDate > .now
    }

    public var canSubmit: Bool {
        isNumberValid && isExpiryValid && documentData != nil && submitState != .submitting
    }

    public func submit() async {
        guard let documentData, canSubmit else { return }
        submitState = .submitting
        do {
            let user = try await repository.submitTradeLicense(
                number: licenseNumber,
                expiresAt: expiryDate,
                documentData: documentData,
                for: userID
            )
            if isOffline {
                submitState = .queuedOffline
            } else {
                SofrinoHaptics.confirm()
                submitState = .idle
            }
            onSubmitted?(user)
        } catch let error as AuthError {
            SofrinoHaptics.error()
            submitState = .failed(error.userFacingMessage)
        } catch {
            SofrinoHaptics.error()
            submitState = .failed("Couldn't submit your trade license. Please try again.")
        }
    }
}
