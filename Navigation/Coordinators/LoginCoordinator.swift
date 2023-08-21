import UIKit

final class LoginCoordinator {
    
    var navigationController: UINavigationController?
    
    func showProfile(forUser user: User) {
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.navigationController = navigationController
        profileCoordinator.start(forUser: user)
    }
}
