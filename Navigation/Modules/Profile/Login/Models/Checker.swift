
import UIKit

final class Checker {
    
    static let shared = Checker()
    
#if DEBUG
    private let login = testUser.fullName
    private let password = testUser.password
#else
    private let login = user.login
    private let password = user.password
#endif
    
    
    private init() {}
    
    func check(login: String, password: String) throws -> Bool {
        
        guard !login.isEmpty, !password.isEmpty else {
            if login.isEmpty {
                throw LoginError.emptyUserName
            } else {
                throw LoginError.emptyPassword
            }
        }
        
        if login == self.login && password == self.password {
            return true
        } else if login == self.login {
            throw LoginError.invalidPassword
        } else if password == self.password {
            throw LoginError.invalidUserName
        } else {
            throw LoginError.unauthorized
        }
    }
    
}
