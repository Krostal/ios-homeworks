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
    
    private let localAuthorizationService: BiometryClient = LocalAuthorizationService()
    
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
        setupBiometryButton()
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
    
    private func setupBiometryButton() {
        switch localAuthorizationService.availableBiometricType {
        case .faceID:
            loginView.biometryButton.setImage(UIImage(systemName: "faceid"), for: .normal)
            loginView.biometryButton.setTitle("Log in with".localized + " Face ID", for: .normal)
        case .touchID:
            loginView.biometryButton.setImage(UIImage(systemName: "touchid"), for: .normal)
            loginView.biometryButton.setTitle("Войти с помощью".localized + " Touch ID", for: .normal)
        case .none:
            loginView.biometryButton.isHidden = true
        }
    }

}

extension LoginViewController: LoginViewDelegate {
    
    func loginWithBiometry(login: String, password: String) {
        
        localAuthorizationService.authorizeIfPossible { result in
            switch result {
            case .success:
                print("Authorization successful!")
                // симуляция соответствия биометрии
                self.loginButtonPressed(login: login, password: password)
            case .failure(let error):
                print("Biometric authorization error: \(error.localizedDescription)")
                
                Alert().showAlert(on: self, title: "Error".localized, message: "Failed to log in using biometrics".localized + ": \(error.localizedDescription)")
            }
        }
    }
    
    func signUpButtonPressed() {
        loginCoordinator?.showSignUpCoordinator()
    }
    
    func loginButtonPressed(login: String, password: String) {
        loginDelegate.checkCredentials(email: login, password: password, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_ ):
                self.loginCoordinator?.updateTabBar()
            case .failure(let error):
                Alert().showAlert(on: self, title: "Error".localized + " ❌", message: error.localizedDescription)
                print("❌", error.localizedDescription)
            }
        })
    }
}
        

            
    

