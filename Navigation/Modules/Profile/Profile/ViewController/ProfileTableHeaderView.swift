import UIKit

protocol ProfileTableHeaderViewDelegate: AnyObject {
    func didTapMyMusicButton()
    func didTapMyVideoButton()
    func didTapRecordButton()
}

class ProfileTableHeaderView: UIView {
    
    weak var delegate: ProfileTableHeaderViewDelegate?
    
    var user: UserModel? {
        didSet {
            if let currentUser = user {
                fullNameLabel.text = currentUser.name
                statusLabel.text = currentUser.status
                avatarImageView.image = currentUser.avatar
            }
        }
    }
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16.0
        static let avatarWidth: CGFloat = 130.0
        static let returnButtonPadding: CGFloat = 16.0
        static let fullNameSize: CGFloat = 18.0
    }
    
    private lazy var avatarImageView: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.borderWidth = 3
        avatar.layer.cornerRadius = 65
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFit
        return avatar
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let fullName = UILabel()
        fullName.translatesAutoresizingMaskIntoConstraints = false
        fullName.textColor = ColorPalette.textColor
        fullName.font = .systemFont(ofSize: 18, weight: .bold)
        return fullName
    }()
    
    private lazy var mediaStackView: UIStackView = {
        let mediaStackView = UIStackView()
        mediaStackView.translatesAutoresizingMaskIntoConstraints = false
        mediaStackView.axis = .horizontal
        mediaStackView.alignment = .fill
        mediaStackView.distribution = .equalSpacing
        mediaStackView.addArrangedSubview(musicButton)
        mediaStackView.addArrangedSubview(videoButton)
        mediaStackView.addArrangedSubview(recordButton)
        return mediaStackView
    }()
    
    private lazy var musicButton: UIButton = {
        let musicButton = UIButton(type: .system)
        configureButton(musicButton, title: "Music".localized, imageName: "airpodsmax")
        musicButton.addTarget(self, action: #selector(musicButtonTapped), for: .touchUpInside)
        return musicButton
    }()
    
    private lazy var videoButton: UIButton = {
        let videoButton = UIButton(type: .system)
        configureButton(videoButton, title: "Video".localized, imageName: "video.fill")
        videoButton.addTarget(self, action: #selector(videoButtonTapped), for: .touchUpInside)
        return videoButton
    }()
    
    private lazy var recordButton: UIButton = {
        let recordButton = UIButton(type: .system)
        configureButton(recordButton, title: "Rec".localized, imageName: "record.circle")
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        return recordButton
    }()
    
    private lazy var statusLabel: UILabel = {
        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.textColor = .systemGray
        status.font = .systemFont(ofSize: 14, weight: .regular)
        return status
    }()
    
    private lazy var statusTextField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: "Set your status".localized,
            fontSize: 15
        )
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    
    private lazy var setStatusButton = CustomButton(
        title: "Set status".localized,
        backgroundColor: .systemBlue,
        cornerRadius: 14,
        setupButton: { button in
            button.layer.shadowOffset = CGSize(width: 4, height: 4)
            button.layer.shadowOpacity = 0.7
            button.layer.shadowRadius = 4
        },
        action: { [weak self] in
            if let newStatus = self?.statusTextField.text {
                self?.statusLabel.text = newStatus
            }
        })
    
    private lazy var returnAvatarButton = UIButton()
    private lazy var avatarBackground = UIView()
    
    private lazy var avatarOriginPoint = CGPoint()
    private lazy var newStatus = ""
    
    func configureButton(_ button: UIButton, title: String, imageName: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.setTitle(title.localized, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.imageView?.contentMode = .scaleAspectFit
        button.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        clickAvatarImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: frame.width, height: 220.0)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       if #available(iOS 13.0, *) {
           if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
               avatarImageView.layer.borderColor = ColorPalette.borderColor.cgColor
               setStatusButton.layer.shadowColor = ColorPalette.shadowColor.cgColor
               statusTextField.layer.borderColor = ColorPalette.borderColor.cgColor

           }
       }
    }

    private func setupConstraints() {
        
        let safeAreaGuide = safeAreaLayoutGuide
        
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(mediaStackView)
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
            fullNameLabel.heightAnchor.constraint(equalToConstant: Constants.fullNameSize),
            
            mediaStackView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 10),
            mediaStackView.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            mediaStackView.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            mediaStackView.heightAnchor.constraint(equalToConstant: Constants.fullNameSize),
            
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
        
        musicButton.widthAnchor.constraint(equalTo: videoButton.widthAnchor).isActive = true
        videoButton.widthAnchor.constraint(equalTo: recordButton.widthAnchor).isActive = true
        
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
            
            returnAvatarButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.returnButtonPadding),
            returnAvatarButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.returnButtonPadding),
        ])
        
    }
    
    func updateUserInfo(_ user: UserModel) {
        if self.user != nil {
            fullNameLabel.text = user.name
            statusLabel.text = user.status
            avatarImageView.image = user.avatar
        }
    }
    
    @objc func musicButtonTapped(_ sender: UIButton) {
        delegate?.didTapMyMusicButton()
    }
    
    @objc func videoButtonTapped(_ sender: UIButton) {
        delegate?.didTapMyVideoButton()
    }
    
    @objc func recordButtonTapped(_ sender: UIButton) {
        delegate?.didTapRecordButton()
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        if statusTextField.text != nil {
            newStatus = statusTextField.text!
        }
    }
    
    @objc private func tapOnAvatar() {
        
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
            self.returnAvatarButton.alpha = 0
            self.avatarImageView.center = self.avatarOriginPoint
            self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
            self.avatarImageView.layer.borderWidth = 3
            self.avatarImageView.layer.borderColor = ColorPalette.borderColor.cgColor
            self.avatarBackground.alpha = 0
        } completion: { _ in
            ProfileViewController.tableView.isScrollEnabled = true
            ProfileViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }

}
                                   
