import Foundation
import Observation
import SofrinoCore
import SofrinoDesignSystem

@MainActor
@Observable
public final class OTPVerificationViewModel {
    public enum SubmitState: Equatable {
        case idle
        case verifying
        case failed(String)
    }

    public let phoneNumber: String
    public var code: String = "" {
        didSet {
            if case .failed = submitState { submitState = .idle }
            if code.count == 6, oldValue.count != 6 {
                Task { await verify() }
            }
        }
    }
    public private(set) var submitState: SubmitState = .idle
    public private(set) var resendCooldownSeconds: Int = 60
    public private(set) var isResending = false

    /// Invoked once verification succeeds, carrying the resulting session
    /// so the flow coordinator can decide the next screen: role selection
    /// for a brand-new user, or straight to the home screen for a returning one.
    public var onVerified: ((AuthSession) -> Void)?

    private let repository: AuthRepository
    private var cooldownTask: Task<Void, Never>?

    public init(phoneNumber: String, repository: AuthRepository) {
        self.phoneNumber = phoneNumber
        self.repository = repository
        startCooldown()
    }

    deinit {
        cooldownTask?.cancel()
    }

    public var maskedPhoneNumber: String {
        guard let phone = UAEPhoneNumber(rawInput: phoneNumber) else { return phoneNumber }
        let national = phone.formattedNational
        return "+971 " + national
    }

    public var canResend: Bool {
        resendCooldownSeconds == 0 && !isResending
    }

    public func verify() async {
        guard code.count == 6 else { return }
        submitState = .verifying
        do {
            let session = try await repository.verifyOTP(phoneNumber: phoneNumber, code: code)
            SofrinoHaptics.confirm()
            submitState = .idle
            onVerified?(session)
        } catch let error as AuthError {
            SofrinoHaptics.error()
            submitState = .failed(error.userFacingMessage)
            code = ""
        } catch {
            SofrinoHaptics.error()
            submitState = .failed("Something went wrong. Please try again.")
            code = ""
        }
    }

    public func resend() async {
        guard canResend else { return }
        isResending = true
        defer { isResending = false }
        do {
            try await repository.requestOTP(phoneNumber: phoneNumber)
            SofrinoHaptics.tap()
            startCooldown()
        } catch let error as AuthError {
            submitState = .failed(error.userFacingMessage)
        } catch {
            submitState = .failed("Couldn't resend the code. Please try again.")
        }
    }

    private func startCooldown() {
        resendCooldownSeconds = 60
        cooldownTask?.cancel()
        cooldownTask = Task { [weak self] in
            while let self, self.resendCooldownSeconds > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                self.resendCooldownSeconds -= 1
            }
        }
    }
}
