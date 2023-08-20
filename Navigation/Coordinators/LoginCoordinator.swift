import UIKit

final class LoginCoordinator {
    
    var navigationController: UINavigationController?
    
    func showProfile(forUser user: User) {
        let profileViewController = ProfileViewController()
        profileViewController.currentUser = user
        navigationController?.pushViewController(profileViewController, animated: true)
        
    }
}


