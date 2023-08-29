
import UIKit

protocol LoginViewControllerDelegate {
    func check(
        _ sender: LoginViewController,
        login: String,
        password: String
    ) -> Bool
}

class LoginViewController: UIViewController {
    
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

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        
        if login.isEmpty {
            showAlert(title: "Error", message: "Please enter a valid login.")
        }
        
        if password.isEmpty {
            showAlert(title: "Error", message: "Please enter a password.")
        }
        
        if let user = userService.authorizeUser(login: login) {
            if loginDelegate.check(self, login: login, password: password) {
                loginCoordinator?.showProfile(forUser: user)
            } else {
                showAlert(title: "Error", message: "Invalid login or password.")
            }
        } else {
            showAlert(title: "Error", message: "Invalid login or user not found.")
        }
    }
}
