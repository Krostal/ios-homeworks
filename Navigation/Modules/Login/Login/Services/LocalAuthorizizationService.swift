

import LocalAuthentication

final class LocalAuthorizationService {
    
    var error: NSError?

    private func authenticateWithBiometrics(completion: @escaping (Result<Bool, Error>) -> Void) {
        let context = LAContext()
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorization by biometrics".localized) { success, error in
            if success {
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } else {
                if let error = error {
                    print("Biometric authorization error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

extension LocalAuthorizationService: BiometryClient {
    
    var availableBiometricType: BiometryType {
        let type = BiometryType.currentType()

        if type == .none, let error = error {
            self.error = error
        }

        return type
    }

    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, Error>) -> Void) {
        guard availableBiometricType != .none else {
            authorizationFinished(.failure(error ?? AuthenticationError.biometricsNotAvailable))
            return
        }

        authenticateWithBiometrics { result in
            authorizationFinished(result)
        }
    }

    func canUseBiometrics() -> Bool {
        return availableBiometricType != .none
    }
    
    
}
