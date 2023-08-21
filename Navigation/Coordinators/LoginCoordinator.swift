import UIKit

final class LoginCoordinator {
    
    var navigationController: UINavigationController?
    
    init() {
        navigationController = UINavigationController() 
    }
    
    func start() -> UINavigationController {
        let userService: UserService
        let loginFactory = MyLoginFactory()
        let loginInspector = loginFactory.makeLoginInspector()
        
        #if DEBUG
        let testUserService = TestUserService(testUser: testUser)
        userService = testUserService
        #else
        let currentUserService = CurrentUserService(currentUser: groot)
        userService = currentUserService
        #endif
        
        let loginViewController = LoginViewController(userService: userService, loginDelegate: loginInspector)
        loginViewController.loginCoordinator = self
        
        navigationController?.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
        navigationController?.setViewControllers([loginViewController], animated: true)
        
        if let loginNavigationController = navigationController?.viewControllers.first as? LoginViewController {
            loginNavigationController.loginDelegate = loginInspector
        }
        
        return navigationController!
    }
    
    func showProfile(forUser user: User) {
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.navigationController = navigationController
        profileCoordinator.start(forUser: user)
    }
}
