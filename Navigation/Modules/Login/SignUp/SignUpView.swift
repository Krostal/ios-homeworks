import UIKit

protocol SignUpViewDelegate: AnyObject {
    func signedUpNewUser(username: String, email: String, password: String)
}

final class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?
    
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
        registerField.addArrangedSubview(userNameField)
        registerField.addArrangedSubview(separator1)
        registerField.addArrangedSubview(emailField)
        registerField.addArrangedSubview(separator2)
        registerField.addArrangedSubview(passwordField)
        return registerField
    }()
    
    private lazy var separator1: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray2
        return separator
    }()
    
    private lazy var separator2: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray2
        return separator
    }()
    
    private lazy var userNameField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Username".localized, fontSize: 16)
        return textField
    }()
    
    private lazy var emailField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Email".localized, fontSize: 16)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var passwordField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Password".localized, fontSize: 16)
        return textField
    }()
    
    
    private lazy var signUpButton = CustomButton(
        title: "Sign Up".localized,
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
    
    init() {
        super.init(frame: .zero)
        setupView()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
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
        contentView.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.widthAnchor.constraint(equalToConstant: 100),
            
            registerField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 60),
            registerField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            registerField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            userNameField.topAnchor.constraint(equalTo: registerField.topAnchor),
            userNameField.heightAnchor.constraint(equalToConstant: 50),
            userNameField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            separator1.topAnchor.constraint(equalTo: userNameField.bottomAnchor),
            separator1.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 0.5),
            
            emailField.topAnchor.constraint(equalTo: separator1.bottomAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            emailField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            separator2.topAnchor.constraint(equalTo: emailField.bottomAnchor),
            separator2.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 0.5),
            
            passwordField.topAnchor.constraint(equalTo: separator2.bottomAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.widthAnchor.constraint(equalTo: registerField.widthAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: registerField.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: registerField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: registerField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    private func buttonPressed() {
        guard let username = userNameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        delegate?.signedUpNewUser(username: username, email: email, password: password)
    }
    
}
