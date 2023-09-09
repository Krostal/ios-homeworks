
import UIKit

struct LoginInspector: LoginViewControllerDelegate {
    
    func check(_ sender: LoginViewController, login: String, password: String) throws -> Bool {
        try Checker.shared.check(login: login, password: password)
    }
    
}
