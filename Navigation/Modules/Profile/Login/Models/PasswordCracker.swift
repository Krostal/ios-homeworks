import UIKit

class PasswordCracker {
    
    private let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    func bruteForce(targetPassword: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let crackedPassword = self.generateBruteForce(targetPassword: targetPassword, currentPassword: "") {
                DispatchQueue.main.async {
                    completion(crackedPassword)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func generateBruteForce(targetPassword: String, currentPassword: String) -> String? {
        if currentPassword == targetPassword {
            return currentPassword
        }
        
        if currentPassword.count >= targetPassword.count {
            return nil
        }
        
        for char in characters {
            if let crackedPassword = generateBruteForce(targetPassword: targetPassword, currentPassword: currentPassword + String(char)) {
                return crackedPassword
            }
        }
        
        return nil
    }
}
