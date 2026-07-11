import Foundation
import SofrinoCore

/// Domain-specific auth failures, layered on top of `NetworkError` so view
/// models can distinguish "the phone number is malformed" (a validation
/// concern, shown inline under the field) from "the network is down" (an
/// app-wide offline banner concern) from "the code was wrong" (an OTP-field
/// shake + specific message).
public enum AuthError: Error, Equatable, Sendable {
    case invalidPhoneNumber
    case invalidOTP
    case otpExpired
    case tradeLicenseInvalid(reason: String)
    case network(NetworkError)

    public var userFacingMessage: String {
        switch self {
        case .invalidPhoneNumber:
            return "Enter a valid UAE mobile number."
        case .invalidOTP:
            return "That code didn't match. Try again."
        case .otpExpired:
            return "This code has expired. Request a new one."
        case .tradeLicenseInvalid(let reason):
            return reason
        case .network(let networkError):
            return networkError.userFacingMessage
        }
    }
}
