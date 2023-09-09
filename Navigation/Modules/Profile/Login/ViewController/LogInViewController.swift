
import UIKit

protocol LoginViewControllerDelegate {
    func check(_ sender: LoginViewController, login: String, password: String) throws -> Bool
}

class LoginViewController: UIViewController {
    
    let alert = Alert()
    
    var loginDelegate: LoginViewControllerDelegate
    
    var loginCoordinator: LoginCoordinator?
    
    private var keyboardObserver: NSObjectProtocol?
    
    private let userService: UserService
    
    private var loginView: LoginView
    
    init(userService: UserService, loginDelegate: LoginViewControllerDelegate) {
        self.userService = userService
        self.loginDelegate = loginDelegate
        self.loginView = LoginView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    private func setupLoginView() {
        view = loginView
        loginView.delegate = self
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupKeyboardObservers() {
        keyboardObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardFrameWillChange(notification)
        }
    }
    
    private func removeKeyboardObservers() {
        if let observer = keyboardObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func keyboardFrameWillChange(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = view.window
        else {
            return
        }
        
        let keyboardFrameEndInWindow = window.convert(keyboardFrameEnd, from: nil)
        let intersection = loginView.scrollView.frame.intersection(keyboardFrameEndInWindow)
        
        if intersection.isNull {
            loginView.scrollView.contentInset.bottom = 0
        } else {
            loginView.scrollView.contentInset.bottom = intersection.height + 16
        }

        loginView.scrollView.scrollIndicatorInsets = loginView.scrollView.contentInset
        
    }

}

extension LoginViewController: LoginViewDelegate {
    func loginButtonPressed(login: String, password: String) {
        
        do {
            if login.isEmpty {
                throw LoginError.emptyUserName
            }
            if password.isEmpty {
                throw LoginError.emptyPassword
            }
            if let user = try userService.authorizeUser(login: login) {
                if try loginDelegate.check(self, login: login, password: password) {
                    loginCoordinator?.showProfile(forUser: user)
                }
            }
        } catch LoginError.emptyUserName {
            alert.showAlert(on: self, title: "Username is empty", message: "Please enter your username")
        } catch LoginError.emptyPassword {
            alert.showAlert(on: self, title: "Password is empty", message: "Enter your password, please")
        } catch LoginError.invalidPassword {
            alert.showAlert(on: self, title: "Invalid Password", message: "The entered password is invalid. Please check the password and try again")
        } catch LoginError.invalidUserName {
            alert.showAlert(on: self, title: "Invalid Username", message: "The entered username is invalid. Please check the spelling and try again")
        } catch {
            alert.showAlert(on: self, title: "Unknown Error", message: "Please try again later")
        }
            
    }
    
}
