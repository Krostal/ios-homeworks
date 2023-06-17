
import UIKit

class ProfileViewController: UIViewController {
    
    let profileHeaderView = ProfileHeaderView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(profileHeaderView)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.title = "Profile"
        profileHeaderView.setupUI()
        profileHeaderView.statusButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileHeaderView.frame = view.frame
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        print("status")
    }
    
}
