import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButtonPressed(login: String, password: String)
}

final class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    private(set) lazy var scrollView: UIScrollView = {
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
            self?.buttonPressed()
        })
    
    init() {
        super.init(frame: .zero)
        setupView()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
        defaultLoginAndPassword()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
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
    
    @objc private func buttonPressed() {
        guard let login = emailOrPhoneField.text else { return }
        guard let password = passwordField.text else { return }
        delegate?.loginButtonPressed(login: login, password: password)
    }
}
