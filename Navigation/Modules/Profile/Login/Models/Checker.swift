
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
    
    func check(login: String, password: String) -> Bool {
        login == self.login && password == self.password
    }
    
}
