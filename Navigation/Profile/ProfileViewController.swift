
import UIKit

class ProfileViewController: UIViewController {
    
    let profileHeaderView = ProfileHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        view.addSubview(profileHeaderView)
        profileHeaderView.backgroundColor = .lightGray
        self.navigationItem.title = "Profile"
        profileHeaderView.setupUI()
        profileHeaderView.statusButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileHeaderView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        var actualStatus: String
        if profileHeaderView.profileStatus.placeholder != nil {
            actualStatus = profileHeaderView.profileStatus.placeholder!
            print(actualStatus)
        }
    }
    
}
