

import LocalAuthentication

protocol BiometryClient {
    var availableBiometricType: BiometryType { get }
    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, Error>) -> Void)
    func canUseBiometrics() -> Bool
}

enum BiometryType {
    case none
    case touchID
    case faceID

    static func currentType() -> BiometryType {
        let context = LAContext()

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            return context.biometryType == .faceID ? .faceID : .touchID
        } else {
            return .none
        }
    }
}
