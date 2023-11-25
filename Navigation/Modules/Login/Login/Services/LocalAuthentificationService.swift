

import LocalAuthentication
import UIKit

class LocalAuthorizationService {
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    var error: NSError?
    
    var availableBiometricType: BiometricType {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            if let error = error {
                self.error = error
                return .none
            }
            
            return context.biometryType == .faceID ? .faceID : .touchID
        } else {
            return .none
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, Error?) -> Void) {
        guard availableBiometricType != .none else {
            authorizationFinished(false, error)
            return
        }
        
        authenticateWithBiometrics { success, error in
            authorizationFinished(success, error)
        }
    }
    
    private func canUseBiometrics() -> Bool {
        let context = LAContext()
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    private func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authorization by biometrics".localized) { success, error in
            if success {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                if let error = error {
                    print("Biometric authorization error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
    }
}
