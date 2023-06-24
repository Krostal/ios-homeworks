
import UIKit

class LogInViewController: UIViewController {
    
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
        registerField.clipsToBounds = true
        registerField.layer.cornerRadius = 10
        registerField.layer.borderWidth = 0.5
        registerField.layer.borderColor = UIColor.lightGray.cgColor
        registerField.addArrangedSubview(emailOrPhoneField)
        registerField.addArrangedSubview(passwordField)
        return registerField
    }()
    
    private lazy var emailOrPhoneField: UITextField = {
        let emailOrPhone = TextFieldWithPadding()
        emailOrPhone.translatesAutoresizingMaskIntoConstraints = false
        emailOrPhone.placeholder = "Email or phone"
        emailOrPhone.textColor = .black
        emailOrPhone.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emailOrPhone.autocapitalizationType = .none
        emailOrPhone.layer.borderWidth = 0.25
        emailOrPhone.layer.borderColor = UIColor.lightGray.cgColor
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
        password.layer.borderWidth = 0.25
        password.layer.borderColor = UIColor.lightGray.cgColor
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
        button.setTitle("Log In", for: .normal)
        button.setBackgroundImage(UIImage(named: "bluePixel"), for: .normal)
        button.automaticallyUpdatesConfiguration = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
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
        
        registerField.addSubview(emailOrPhoneField)
        registerField.addSubview(passwordField)
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
            emailOrPhoneField.heightAnchor.constraint(equalToConstant: 50),
            emailOrPhoneField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            passwordField.topAnchor.constraint(equalTo: emailOrPhoneField.bottomAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
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
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }

    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0

    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let profileViewController = ProfileViewController()
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
}

extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()

        return false
    }
}
