
import UIKit

final class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("ProfileCoordinator requires a user to start.")
    }

    func start(forUser user: User) {
        let profileViewController = ProfileViewController()
        profileViewController.currentUser = user
        navigationController.pushViewController(profileViewController, animated: true)
    }
}

