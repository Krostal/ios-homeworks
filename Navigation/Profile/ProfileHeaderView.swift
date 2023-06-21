import UIKit

class ProfileHeaderView: UIView {
    
    private lazy var profileName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Cool Monkey"
        name.font = .systemFont(ofSize: 18, weight: .bold)
        name.textColor = .black
        return name
    }()
    
    private lazy var profilePhoto: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "Cool monkey")
        photo.frame.size = CGSize(width: 100, height: 100)
        photo.layer.cornerRadius = 50
        photo.clipsToBounds = true
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.borderWidth = 3
        return photo
    }()
    
    private lazy var profileStatus: UILabel = {
        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Waiting for something..."
        status.font = .systemFont(ofSize: 14, weight: .regular)
        status.textColor = .gray
        return status
    }()
    
    private lazy var setStatusField: TextFieldWithPadding = {
        let setStatus = TextFieldWithPadding()
        setStatus.translatesAutoresizingMaskIntoConstraints = false
        setStatus.placeholder = "Type something..."
        setStatus.font = .systemFont(ofSize: 15, weight: .regular)
        setStatus.layer.backgroundColor = UIColor.white.cgColor
        setStatus.layer.cornerRadius = 12
        setStatus.layer.borderWidth = 1
        setStatus.layer.borderColor = UIColor.black.cgColor
        setStatus.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        return setStatus
    }()
    
    private lazy var statusButton: UIButton = {
        let showStatusButton = UIButton()
        showStatusButton.setTitle("Show status", for: .normal)
        showStatusButton.setTitleColor(.white, for: .normal)
        showStatusButton.backgroundColor = .systemBlue
        showStatusButton.translatesAutoresizingMaskIntoConstraints = false
        showStatusButton.layer.cornerRadius = 14 // по заданию - 4pt, но скругления при таких параметрах практически нет
        showStatusButton.layer.shadowOffset = .init(width: 4, height: 4)
        showStatusButton.layer.shadowRadius = 4
        showStatusButton.layer.shadowOpacity = 0.7
        showStatusButton.layer.shadowColor = UIColor.black.cgColor
        showStatusButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return showStatusButton
    }()
    
    private lazy var actualStatus: String = ""
    
    private lazy var statusText: String = ""
    
    private func setupConstraints() {
        
        addSubview(profilePhoto)
        addSubview(profileName)
        addSubview(statusButton)
        addSubview(profileStatus)
        addSubview(setStatusField)

        UIKit.NSLayoutConstraint.activate([
            profilePhoto.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            profilePhoto.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            profilePhoto.widthAnchor.constraint(
                equalToConstant: 100
            ),
            profilePhoto.heightAnchor.constraint(
                equalToConstant: 100
            ),
    
    
            profileName.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 27
            ),
            profileName.heightAnchor.constraint(
                equalToConstant: 18
            ),
            profileName.leadingAnchor.constraint(
                equalTo: profilePhoto.trailingAnchor,
                constant: 16
            ),
            profileName.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
    
            statusButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            statusButton.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            statusButton.topAnchor.constraint(
                equalTo: profilePhoto.bottomAnchor,
                constant: 36
            ),
            statusButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
    
  
            profileStatus.bottomAnchor.constraint(
                equalTo: statusButton.topAnchor,
                constant: -54
            ),
            profileStatus.leadingAnchor.constraint(
                equalTo: profileName.leadingAnchor
            ),
            profileStatus.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),

            setStatusField.topAnchor.constraint(
                equalTo: profileStatus.bottomAnchor,
                constant: 2
            ),
            setStatusField.heightAnchor.constraint(
                equalToConstant: 40
            ),
            setStatusField.leadingAnchor.constraint(
                equalTo: profileName.leadingAnchor
            ),
            setStatusField.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            )
        ])
        
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        if statusButton.currentTitle == "Set status" {
            profileStatus.text = statusText
        }
        else {
            if profileStatus.text != nil {
                actualStatus = profileStatus.text!
                print(actualStatus)
            }
        }
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if setStatusField.text != nil {
            statusText = setStatusField.text!
            if statusText != "" {
                statusButton.setTitle("Set status", for: .normal)
            } else {
                statusButton.setTitle("Show status", for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
