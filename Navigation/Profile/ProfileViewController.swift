
import UIKit

class ProfileViewController: UIViewController {

    let profileHeaderView = ProfileHeaderView()

    private var newStatus = ""
    
    private lazy var newButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("New button", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        setupView()
        self.navigationItem.title = "Profile"
        profileHeaderView.backgroundColor = .lightGray
        view.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        profileHeaderView.setupConstraints()
        profileHeaderView.setStatusButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        profileHeaderView.statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        if profileHeaderView.statusTextField.text != nil {
            profileHeaderView.statusLabel.text = newStatus
        }
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        if profileHeaderView.statusTextField.text != nil {
            newStatus = profileHeaderView.statusTextField.text!
        }
    }
    
    private func setupView() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        view.addSubview(newButton)
        
        NSLayoutConstraint.activate([
            profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            profileHeaderView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
            
            newButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            newButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            newButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            newButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}
