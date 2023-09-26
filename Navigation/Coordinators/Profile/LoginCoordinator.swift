import UIKit

final class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, checkerService: CheckerServiceProtocol) {
        self.navigationController = navigationController
    }

    func start() {
        
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        if CheckerService.shared.isLogIn {
            if let currentUser = CheckerService.shared.currentUser {
                showProfile(forUser: currentUser)
                return
            }
        } else {
            showLogin()
        }
        
    }
    
    func showLogin() {
        let loginFactory = MyLoginFactory()
        let loginInspector = loginFactory.makeLoginInspector()

        let loginViewController = LoginViewController(loginDelegate: loginInspector)
        loginViewController.loginCoordinator = self

        navigationController.setViewControllers([loginViewController], animated: true)

        if let loginNavigationController = navigationController.viewControllers.first as? LoginViewController {
            loginNavigationController.loginDelegate = loginInspector
        }
    }
    
    func showProfile(forUser user: UserModel) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.delegate = self
        addChildCoordinator(profileCoordinator)
        profileCoordinator.start(forUser: user)
        removeChildCoordinator(self)
    }
    
    func showSignUpCoordinator() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        signUpCoordinator.delegate = self
        addChildCoordinator(signUpCoordinator)
        signUpCoordinator.start()
    }
    
    func updateTabBar() {
        MainCoordinator.shared.updateTabBarController()
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

extension LoginCoordinator: SignUpCoordinatorDelegate {
    func signUpCoordinatorDidFinish(_ coordinator: SignUpCoordinator) {
        removeChildCoordinator(coordinator)
    }
}


