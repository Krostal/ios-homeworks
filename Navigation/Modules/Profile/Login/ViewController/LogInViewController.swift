import UIKit

protocol LoginViewControllerDelegate {
    
    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, AuthenticationError>) -> Void
    )
}

class LoginViewController: UIViewController {
    
    var loginDelegate: LoginViewControllerDelegate
    
    var loginCoordinator: LoginCoordinator?
    
    private var keyboardObserver: NSObjectProtocol?
    
    private var loginView: LoginView
    
    init(loginDelegate: LoginViewControllerDelegate) {
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
        print(CheckerService.shared.isLogIn)
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
            loginView.scrollView.contentInset.bottom = intersection.height + 5
        }

        loginView.scrollView.scrollIndicatorInsets = loginView.scrollView.contentInset
        
    }

}

extension LoginViewController: LoginViewDelegate {
    
    func signUpButtonPressed() {
        loginCoordinator?.showSignUpCoordinator()
    }
    
    func loginButtonPressed(login: String, password: String) {
        loginDelegate.checkCredentials(email: login, password: password, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.loginCoordinator?.showProfile(forUser: user)
            case .failure(let error):
                Alert().showAlert(on: self, title: "Error ❌", message: error.errorDescription)
                print("❌", error.errorDescription)
            }
        })
    }
}
        

            
    

