import Foundation
import Observation
import SofrinoCore
import SofrinoDesignSystem

@MainActor
@Observable
public final class PhoneEntryViewModel {
    public enum SubmitState: Equatable {
        case idle
        case submitting
        case failed(String)
    }

    /// Raw digits as the user types — formatting for display happens in
    /// the view via `UAEPhoneNumber.formattedNational`, keeping this the
    /// single source of truth free of presentation concerns.
    public var rawInput: String = "" {
        didSet { submitState = .idle }
    }

    public private(set) var submitState: SubmitState = .idle
    /// Set by the view when `Reachability` reports no connection, so the
    /// button can disable itself before the user even taps (Design System
    /// §14: don't wait for a doomed request to fail).
    public var isOffline: Bool = false

    /// Invoked with the E.164 phone number once an OTP has been
    /// successfully requested — the flow coordinator (Task 10) uses this to
    /// push the OTP verification screen.
    public var onOTPRequested: ((String) -> Void)?

    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public var parsedPhoneNumber: UAEPhoneNumber? {
        UAEPhoneNumber(rawInput: rawInput)
    }

    public var isValid: Bool {
        parsedPhoneNumber != nil
    }

    public var canSubmit: Bool {
        isValid && submitState != .submitting && !isOffline
    }

    public func submit() async {
        guard let phone = parsedPhoneNumber else {
            submitState = .failed(AuthError.invalidPhoneNumber.userFacingMessage)
            return
        }

        submitState = .submitting
        do {
            try await repository.requestOTP(phoneNumber: phone.e164)
            submitState = .idle
            onOTPRequested?(phone.e164)
        } catch let error as AuthError {
            SofrinoHaptics.error()
            submitState = .failed(error.userFacingMessage)
        } catch {
            SofrinoHaptics.error()
            submitState = .failed("Something went wrong. Please try again.")
        }
    }
}
