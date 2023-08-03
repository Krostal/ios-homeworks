import UIKit

class ProfileTableHeaderView: UIView {
    
    private enum Constants {
            static let horizontalPadding: CGFloat = 16.0
            static let avatarWidth: CGFloat = 130.0
            static let returnButtonpadding: CGFloat = 16.0
        }
    
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
    
    private lazy var returnAvatarButton = UIButton()
    private lazy var avatarBackground = UIView()
    
    private lazy var avatarOriginPoint = CGPoint()
    private lazy var newStatus = ""
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: frame.width, height: 220.0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        clickAvatarImage()
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
            
            avatarImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: Constants.horizontalPadding),
            avatarImageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: Constants.horizontalPadding),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarWidth),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarWidth),
    
            fullNameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.horizontalPadding),
            fullNameLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            fullNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -54),
            statusLabel.heightAnchor.constraint(equalToConstant: 14),
            
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            
            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.horizontalPadding),
            setStatusButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: Constants.horizontalPadding),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func clickAvatarImage() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        
        returnAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        returnAvatarButton.alpha = 0
        returnAvatarButton.backgroundColor = .clear
        returnAvatarButton.contentMode = .scaleToFill
        returnAvatarButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.black, renderingMode: .automatic), for: .normal)
        returnAvatarButton.tintColor = .black
        returnAvatarButton.addTarget(self, action: #selector(returnAvatarToOrigin), for: .touchUpInside)
        
        avatarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        avatarBackground.backgroundColor = .lightGray
        avatarBackground.isHidden = true
        avatarBackground.alpha = 0
        
        addSubview(avatarBackground)
        addSubview(avatarImageView)
        addSubview(returnAvatarButton)
        
        NSLayoutConstraint.activate([
            
            returnAvatarButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.returnButtonpadding),
            returnAvatarButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.returnButtonpadding),
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
    
    @objc private func tapOnAvatar() {
        // create an animation
        avatarImageView.isUserInteractionEnabled = false
        
        ProfileViewController.tableView.isScrollEnabled = false
        ProfileViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
        
        avatarOriginPoint = avatarImageView.center
        let scale = UIScreen.main.bounds.width / avatarImageView.bounds.width
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.center = CGPoint(x: UIScreen.main.bounds.midX,
                                                  y: UIScreen.main.bounds.midY - self.avatarOriginPoint.y)
            self.avatarImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarImageView.layer.borderWidth = 1
            self.avatarImageView.layer.borderColor = UIColor.systemBackground.cgColor
            self.avatarBackground.isHidden = false
            self.avatarBackground.alpha = 0.5
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.returnAvatarButton.alpha = 1
            }
        }
    }
    
    @objc private func returnAvatarToOrigin() {
        UIImageView.animate(withDuration: 0.5) {
            UIImageView.animate(withDuration: 0.5) {
                self.returnAvatarButton.alpha = 0
                self.avatarImageView.center = self.avatarOriginPoint
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                self.avatarImageView.layer.borderWidth = 3
                self.avatarImageView.layer.borderColor = UIColor.white.cgColor
                self.avatarBackground.alpha = 0
            }
        } completion: { _ in
            ProfileViewController.tableView.isScrollEnabled = true
            ProfileViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }

}
                                   
