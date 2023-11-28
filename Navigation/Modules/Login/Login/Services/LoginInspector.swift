

import FirebaseAuth

struct LoginInspector: LoginViewControllerDelegate {
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<UserModel, AuthenticationError>) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            if signInMethods?.isEmpty == true {
                completion(.failure(.notAuthorized))
            } else {
                CheckerService.shared.checkCredentials(email: email, password: password, completion: completion)
            }
        }
    }
}
