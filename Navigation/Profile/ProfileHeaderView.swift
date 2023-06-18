import UIKit

class ProfileHeaderView: UIView {
    
    lazy var profileName = UILabel()
    
    lazy var profilePhoto = UIImageView()
    
    lazy var profileStatus = UITextField()
    
    lazy var statusButton: UIButton = {
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
        return showStatusButton
    }()
    
    func setupUI() {
        
        addSubview(profilePhoto)
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        profilePhoto.image = UIImage(named: "Cool Monkey")
        profilePhoto.frame.size = CGSize(width: 100, height: 100)
        profilePhoto.layer.cornerRadius = 50
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.borderColor = UIColor.white.cgColor
        profilePhoto.layer.borderWidth = 3
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
            )
        ])
    
        addSubview(profileName)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.text = "Cool Monkey"
        profileName.font = .systemFont(ofSize: 18, weight: .bold)
        profileName.textColor = .black
        UIKit.NSLayoutConstraint.activate([
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
            )
        ])
    
        addSubview(statusButton)
        UIKit.NSLayoutConstraint.activate([
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
                constant: 16
            ),
            statusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    
        addSubview(profileStatus)
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        profileStatus.placeholder = "Waiting for something..."
        profileStatus.font = .systemFont(ofSize: 14, weight: .regular)
        profileStatus.textColor = .gray
        NSLayoutConstraint.activate([
            profileStatus.bottomAnchor.constraint(
                equalTo: statusButton.topAnchor,
                constant: -34
            ),
            profileStatus.leadingAnchor.constraint(
                equalTo: profileName.leadingAnchor
            ),
            profileStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

}
