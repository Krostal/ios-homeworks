
import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func signUpViewControllerDidDisappear()
}

final class SignUpViewController: UIViewController {
    
    weak var delegate: SignUpViewControllerDelegate?
    
    private let signUpView = SignUpView()
    
    private var keyboardObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignUpView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.signUpViewControllerDidDisappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    private func setupSignUpView() {
        view = signUpView
        signUpView.delegate = self
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
        let intersection = signUpView.scrollView.frame.intersection(keyboardFrameEndInWindow)
        
        if intersection.isNull {
            signUpView.scrollView.contentInset.bottom = 0
        } else {
            signUpView.scrollView.contentInset.bottom = intersection.height + 76
        }

        signUpView.scrollView.scrollIndicatorInsets = signUpView.scrollView.contentInset
        
    }
    
}

extension SignUpViewController: SignUpViewDelegate {
    func signedUpNewUser(username: String, email: String, password: String) {
        CheckerService.shared.signUp(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                Alert().showAlert(on: self, title: "Success ✅", message: "User '\(username)' successfully registered") {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                if username.isEmpty {
                    Alert().showAlert(on: self, title: "Error ❌", message: "Username is empty")
                } else {
                    Alert().showAlert(on: self, title: "Error ❌", message: error.errorDescription)
                    print("❌", error.errorDescription)
                }
            }
        }
    }
}

