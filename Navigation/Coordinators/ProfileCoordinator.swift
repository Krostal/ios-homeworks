
import UIKit

final class ProfileCoordinator {
    var navigationController: UINavigationController?
    
    func start(forUser user: User) {
        let profileViewController = ProfileViewController()
        profileViewController.currentUser = user
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
