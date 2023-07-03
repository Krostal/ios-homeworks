import UIKit

class ProfileTableHeaderView: UIView {
    
    private lazy var avatarImageView: UIImageView = {
        let avatar = UIImageView(image: UIImage(named: "Groot"))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.borderWidth = 3
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.cornerRadius = 65
        avatar.clipsToBounds = true
        return avatar
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let fullName = UILabel()
        fullName.translatesAutoresizingMaskIntoConstraints = false
        fullName.text = "Groot"
        fullName.textColor = .black
        fullName.font = .systemFont(ofSize: 18, weight: .bold)
        return fullName
    }()
    
    private lazy var statusLabel: UILabel = {
        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Happy :)"
        status.textColor = .gray
        status.font = .systemFont(ofSize: 14, weight: .regular)
        return status
    }()
    
    private lazy var statusTextField: UITextField = {
        let statusText = TextFieldWithPadding()
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.placeholder = "Set your status"
        statusText.backgroundColor = .white
        statusText.layer.borderWidth = 1
        statusText.layer.borderColor = UIColor.black.cgColor
        statusText.font = .systemFont(ofSize: 15, weight: .regular)
        statusText.textColor = .black
        statusText.layer.cornerRadius = 12
        statusText.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        return statusText
    }()
    
    private lazy var setStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set status", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 14
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var newStatus = ""
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: frame.width, height: 220.0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupConstraints() {
        
        let safeAreaGuide = safeAreaLayoutGuide
        
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(setStatusButton)
        addSubview(statusLabel)
        addSubview(statusTextField)
        
        NSLayoutConstraint.activate([
            
            avatarImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 130),
            avatarImageView.widthAnchor.constraint(equalToConstant: 130),
    
            fullNameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -54),
            statusLabel.heightAnchor.constraint(equalToConstant: 14),
            
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            
            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        if statusTextField.text != nil {
            statusLabel.text = newStatus
        }
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        if statusTextField.text != nil {
            newStatus = statusTextField.text!
        }
    }

}
                                   
