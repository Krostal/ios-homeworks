
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
    
    private lazy var emailOrPhoneField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Email or phone", fontSize: 16)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password", fontSize: 16)
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton = CustomButton(
        title: "Log In",
        backgroundColor: .systemBackground,
        tintColor: .white,
        cornerRadius: 10,
        setupButton: { button in
            button.configurationUpdateHandler = { btn in
                switch btn.state {
                case .highlighted, .disabled, .selected:
                    btn.configuration?.background.image = UIImage(named: "bluePixel")
                    btn.alpha = 0.8
                default:
                    btn.configuration?.background.image = UIImage(named: "bluePixel")
                    btn.alpha = 1
                }
            }
        },
        action: { [weak self] in
            self?.loginButtonPressed()
        })
    
    private func setupTextField(element: UITextField) {
        element.translatesAutoresizingMaskIntoConstraints = false
        element.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        element.textColor = .black
        element.autocapitalizationType = .none
        element.autocorrectionType = .no
        element.keyboardType = .default
        element.returnKeyType = .done
        element.clearButtonMode = .whileEditing
        element.contentVerticalAlignment = .center
        element.delegate = self
    }
    
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
        defaultLoginAndPassword()
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
        contentView.addSubview(loginButton)
        
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
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: registerField.leadingAnchor),
            loginButton.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    private func defaultLoginAndPassword() {
#if DEBUG
        emailOrPhoneField.text = "TestUser"
        passwordField.text = "UserTest"
#else
        emailOrPhoneField.text = "Groot"
        passwordField.text = "g18o15T"
#endif
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
    
    func showAlert(title: String, message: String) {
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
    
    private func loginButtonPressed() {
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
        return true
    }
}

