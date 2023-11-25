import UIKit

protocol LoginViewDelegate: AnyObject {
    func loginButtonPressed(login: String, password: String)
    func signUpButtonPressed()
    func loginWithBiometry(login: String, password: String)
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
        contentView.backgroundColor = ColorPalette.profileBackgroundColor
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
        registerField.addArrangedSubview(userName)
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
    
    private lazy var userName: CustomTextField = {
        let textField = CustomTextField(placeholder: "Username".localized, fontSize: 16)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password".localized, fontSize: 16)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var loginButton = CustomButton(
        title: "Log In".localized,
        backgroundColor: .systemBackground,
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
    
    lazy var biometryButton = CustomButton(
        title: "Log in using biometrics".localized,
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
            self?.biometryButtonPressed()
        })
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton(type: .system)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Don’t have an account".localized + "? " + "Sign Up".localized, for: .normal)
        signUpButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
        signUpButton.backgroundColor = .clear
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return signUpButton
    }()
    
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
        backgroundColor = ColorPalette.profileBackgroundColor
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
        contentView.addSubview(biometryButton)
        contentView.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.widthAnchor.constraint(equalToConstant: 100),
            
            registerField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 120),
            registerField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            registerField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            userName.topAnchor.constraint(equalTo: registerField.topAnchor),
            userName.heightAnchor.constraint(equalToConstant: 49.75),
            userName.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            separator.topAnchor.constraint(equalTo: userName.bottomAnchor),
            separator.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            passwordField.topAnchor.constraint(equalTo: separator.bottomAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 49.75),
            passwordField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            separator.topAnchor.constraint(equalTo: userName.bottomAnchor),
            separator.bottomAnchor.constraint(equalTo: passwordField.topAnchor),
            separator.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            loginButton.topAnchor.constraint(equalTo: registerField.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: registerField.leadingAnchor),
            loginButton.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            biometryButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            biometryButton.leadingAnchor.constraint(equalTo: registerField.leadingAnchor),
            biometryButton.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            biometryButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(greaterThanOrEqualTo: biometryButton.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: registerField.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func defaultLoginAndPassword() {
        
#if DEBUG
        userName.text = CheckerService.shared.currentUser?.email ?? "testUser@mail.ru"
        passwordField.text = CheckerService.shared.currentUser?.password ?? "TestUser"
 
#else
        userName.text = CheckerService.shared.currentUser?.email ?? "groot@gmail.com"
        passwordField.text = CheckerService.shared.currentUser?.password ?? "groot8"
        
#endif
    }
    
    private func buttonPressed() {
        guard let login = userName.text else { return }
        guard let password = passwordField.text else { return }
        delegate?.loginButtonPressed(login: login, password: password)
    }
    
    private func biometryButtonPressed() {
        guard let login = userName.text else { return }
        guard let password = passwordField.text else { return }
        delegate?.loginWithBiometry(login: login, password: password)
    }
    
    @objc private func signUpButtonTapped() {
        delegate?.signUpButtonPressed()
    }
    
}
