
import UIKit

class ProfileViewController: UIViewController {

    let profileHeaderView = ProfileHeaderView()

    private var newStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileHeaderView)
        self.navigationItem.title = "Profile"
        profileHeaderView.backgroundColor = .lightGray
        view.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        profileHeaderView.setupConstraints()
        profileHeaderView.setStatusButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        profileHeaderView.statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
    }
    
    override func viewWillLayoutSubviews() {
        profileHeaderView.frame = view.safeAreaLayoutGuide.layoutFrame
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

}
