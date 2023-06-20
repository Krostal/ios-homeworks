import UIKit

class ProfileHeaderView: UIView {
    
    lazy var profileName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Cool Monkey"
        name.font = .systemFont(ofSize: 18, weight: .bold)
        name.textColor = .black
        return name
    }()
    
    lazy var profilePhoto: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.image = UIImage(named: "Cool Monkey")
        photo.frame.size = CGSize(width: 100, height: 100)
        photo.layer.cornerRadius = 50
        photo.clipsToBounds = true
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.borderWidth = 3
        return photo
    }()
    
    lazy var profileStatus: UILabel = {
        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Waiting for something..."
        status.font = .systemFont(ofSize: 14, weight: .regular)
        status.textColor = .gray
        return status
    }()
    
    lazy var setStatusField: TextFieldWithPadding = {
        let setStatus = TextFieldWithPadding()
        setStatus.translatesAutoresizingMaskIntoConstraints = false
        setStatus.placeholder = "type something..."
        setStatus.font = .systemFont(ofSize: 15, weight: .regular)
        setStatus.layer.backgroundColor = UIColor.white.cgColor
        setStatus.layer.cornerRadius = 12
        setStatus.layer.borderWidth = 1
        setStatus.layer.borderColor = UIColor.black.cgColor
        return setStatus
    }()
    
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
    
    func setupConstraints() {
        
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
                constant: 16
            ),
            statusButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
    
  
            profileStatus.bottomAnchor.constraint(
                equalTo: statusButton.topAnchor,
                constant: -34
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
                constant: 1
            ),
            setStatusField.bottomAnchor.constraint(
                equalTo: statusButton.topAnchor,
                constant: -5
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
    
    

}
