import UIKit

final class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, checkerService: CheckerServiceProtocol) {
        self.navigationController = navigationController
    }

    func start() {
        
        let loginFactory = MyLoginFactory()
        let loginInspector = loginFactory.makeLoginInspector()

        let loginViewController = LoginViewController(loginDelegate: loginInspector)
        loginViewController.loginCoordinator = self
        
        navigationController.tabBarItem = UITabBarItem(title: "LogIn", image: UIImage(systemName: "person.badge.key"), tag: 1)
        navigationController.setViewControllers([loginViewController], animated: true)

        if let loginNavigationController = navigationController.viewControllers.first as? LoginViewController {
            loginNavigationController.loginDelegate = loginInspector
        }
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


extension LoginCoordinator: SignUpCoordinatorDelegate {
    func signUpCoordinatorDidFinish(_ coordinator: SignUpCoordinator) {
        removeChildCoordinator(coordinator)
    }
}


