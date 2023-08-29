
import UIKit

final class Checker {
    
    static let shared = Checker()
    
    #if DEBUG
        private let login = "TestUser"
        private let password = "UserTest"
    #else
        private let login = "Groot"
        private let password = "Gro1"
    #endif
    
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        login == self.login && password == self.password
    }
    
}
