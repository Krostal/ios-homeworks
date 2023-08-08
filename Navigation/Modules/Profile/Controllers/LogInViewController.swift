
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
    
    private let userService: UserService
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var logo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "VKlogo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    private lazy var registerField: UIStackView = {
        let registerField = UIStackView()
        registerField.translatesAutoresizingMaskIntoConstraints = false
        registerField.spacing = 0
        registerField.axis = .vertical
        registerField.backgroundColor = .systemGray6
        registerField.tintColor = UIColor(named: "AccentColor")
        registerField.clipsToBounds = true
        registerField.layer.cornerRadius = 10
        registerField.layer.borderWidth = 0.5
        registerField.layer.borderColor = UIColor.lightGray.cgColor
        registerField.addArrangedSubview(emailOrPhoneField)
        registerField.addArrangedSubview(separator)
        registerField.addArrangedSubview(passwordField)
        return registerField
    }()
    
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        return separator
    }()
    
    private lazy var emailOrPhoneField: UITextField = {
        let emailOrPhone = TextFieldWithPadding()
        emailOrPhone.translatesAutoresizingMaskIntoConstraints = false
        emailOrPhone.placeholder = "Email or phone"
        emailOrPhone.textColor = .black
        emailOrPhone.font = .systemFont(ofSize: 16, weight: .regular)
        emailOrPhone.autocapitalizationType = .none
        emailOrPhone.autocorrectionType = UITextAutocorrectionType.no
        emailOrPhone.keyboardType = UIKeyboardType.default
        emailOrPhone.returnKeyType = UIReturnKeyType.done
        emailOrPhone.clearButtonMode = UITextField.ViewMode.whileEditing
        emailOrPhone.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailOrPhone.delegate = self
        return emailOrPhone
    }()
    
    private lazy var passwordField: UITextField = {
        let password = TextFieldWithPadding()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.placeholder = "Password"
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.autocorrectionType = UITextAutocorrectionType.no
        password.keyboardType = UIKeyboardType.default
        password.returnKeyType = UIReturnKeyType.done
        password.clearButtonMode = UITextField.ViewMode.whileEditing
        password.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        password.delegate = self
        return password
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = UIButton.Configuration.plain()
        button.setTitle("Log In", for: .normal)
        button.tintColor = .white
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted, .disabled, .selected:
                button.configuration?.background.image = UIImage(named: "bluePixel")
                button.alpha = 0.8
            default:
                button.configuration?.background.image = UIImage(named: "bluePixel")
                button.alpha = 1
            }
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    init(userService: UserService, loginDelegate: LoginViewControllerDelegate) {
        self.userService = userService
        self.loginDelegate = loginDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObservers()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        tabBarController?.tabBar.backgroundColor = .systemGray6
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func setupContentOfScrollView() {
        
        contentView.addSubview(logo)
        contentView.addSubview(registerField)
        contentView.addSubview(logInButton)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.widthAnchor.constraint(equalToConstant: 100),
            
            registerField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 120),
            registerField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            registerField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            registerField.heightAnchor.constraint(equalToConstant: 100),
            
            emailOrPhoneField.topAnchor.constraint(equalTo: registerField.topAnchor),
            emailOrPhoneField.heightAnchor.constraint(equalToConstant: 49.75),
            emailOrPhoneField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            separator.topAnchor.constraint(equalTo: emailOrPhoneField.bottomAnchor),
            separator.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            passwordField.topAnchor.constraint(equalTo: separator.bottomAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 49.75),
            passwordField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            separator.topAnchor.constraint(equalTo: emailOrPhoneField.bottomAnchor),
            separator.bottomAnchor.constraint(equalTo: passwordField.topAnchor),
            separator.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            logInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: registerField.leadingAnchor),
            logInButton.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }

    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }

    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0

    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard let login = emailOrPhoneField.text, !login.isEmpty else {
            showAlert(title: "Error", message: "Please enter a valid login.")
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter a password.")
            return
        }
        
        if let user = userService.authorizeUser(login: login) {
            if loginDelegate.check(self, login: login, password: password) {
                let profileViewController = ProfileViewController()
                profileViewController.currentUser = user
                self.navigationController?.pushViewController(profileViewController, animated: true)
            } else {
                showAlert(title: "Error", message: "Invalid login or password.")
            }
        } else {
            showAlert(title: "Error", message: "Invalid login or user not found.")
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

