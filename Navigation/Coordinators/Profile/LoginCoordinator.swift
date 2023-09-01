import UIKit

final class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let userService: UserService
        let loginFactory = MyLoginFactory()
        let loginInspector = loginFactory.makeLoginInspector()
        
        #if DEBUG
        guard let testUser = testUser else {
            preconditionFailure("TestUser is not found")
        }
        let testUserService = TestUserService(testUser: testUser)
        userService = testUserService
        #else
        guard let currentUser = currentUser else {
            preconditionFailure("Current User is not found")
        }
        let currentUserService = CurrentUserService(currentUser: currentUser)
        userService = currentUserService
        #endif
        
        let loginViewController = LoginViewController(userService: userService, loginDelegate: loginInspector)
        loginViewController.loginCoordinator = self
        
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        navigationController.setViewControllers([loginViewController], animated: true)
        
        if let loginNavigationController = navigationController.viewControllers.first as? LoginViewController {
            loginNavigationController.loginDelegate = loginInspector
        }
    }
    
    func showProfile(forUser user: User) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.delegate = self
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start(forUser: user)
    }
}

extension LoginCoordinator: ProfileCoordinatorDelegate {
    func profileCoordinatorDidFinished(_ coordinator: ProfileCoordinator) {
        if coordinator.childCoordinators.isEmpty {
            if let topViewController = navigationController.topViewController,
               !(topViewController is ProfileViewController) {
                removeChildCoordinator(coordinator)
            }
        }
    }
}

