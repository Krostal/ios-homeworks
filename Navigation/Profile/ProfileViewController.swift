
import UIKit

class ProfileViewController: UIViewController {
    
    let profileHeaderView = ProfileHeaderView()
    
    private var actualStatus: String = ""
    
    private var statusText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        view.addSubview(profileHeaderView)
        profileHeaderView.backgroundColor = .lightGray
        self.navigationItem.title = "Profile"
        profileHeaderView.setupUI()
        profileHeaderView.statusButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        profileHeaderView.setStatusField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileHeaderView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        if profileHeaderView.statusButton.currentTitle == "Set status" {
            profileHeaderView.profileStatus.text = statusText
        }
        else {
            if profileHeaderView.profileStatus.text != nil {
                actualStatus = profileHeaderView.profileStatus.text!
                print(actualStatus)
            }
        }
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if profileHeaderView.setStatusField.text != nil {
            statusText = profileHeaderView.setStatusField.text!
            if statusText != "" {
                profileHeaderView.statusButton.setTitle("Set status", for: .normal)
            } else {
                profileHeaderView.statusButton.setTitle("Show status", for: .normal)
            }
        }
    }
    
}
