

@testable import Navigation
import XCTest


struct LoginInspectorMock: LoginViewControllerDelegate {
    
    private let signInMethods: [String]?
    private let error: Error?
    
    init(signInMethods: [String]? = nil, error: Error? = nil) {
        self.signInMethods = signInMethods
        self.error = error
    }
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<UserModel, AuthenticationError>) -> Void) {
        if let error = error {
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
