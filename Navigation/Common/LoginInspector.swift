
import UIKit

struct LoginInspector: LoginViewControllerDelegate {
    
    func check(_ sender: LoginViewController, login: String, password: String) -> Bool {
        Checker.shared.check(login: login, password: password)
    }
    
}
