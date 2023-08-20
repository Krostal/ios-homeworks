import UIKit

final class Factory {
    enum Flow {
        case feedCoordinator
        case loginCoordinator
    }
    
    private let flow: Flow
    private(set) var viewController: UIViewController!
    private(set) var navigationController = UINavigationController()
    
    init(flow: Flow) {
        self.flow = flow
        startModule()
    }
    
    private func startModule() {
        
        switch flow {
            
        case .feedCoordinator:
            
            let feedModel = FeedModel()
            
            let feedCoordinator = FeedCoordinator()
            let feedViewModel = FeedViewModel(model: feedModel, coordinator: feedCoordinator)
            
            let feedViewController = FeedViewController(viewModel: feedViewModel)
            
            feedCoordinator.navigationController = navigationController
            
            navigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "doc.richtext"), tag: 0)
            navigationController.setViewControllers([feedViewController], animated: true)
            
            self.viewController = feedViewController
            
        case .loginCoordinator:
            
            let loginCoordinator = LoginCoordinator()
            
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
            
            loginCoordinator.navigationController = navigationController
            
            navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
            navigationController.setViewControllers([loginViewController], animated: true)
            
            if let loginNavigationController = navigationController.viewControllers.first as? LoginViewController {
                loginNavigationController.loginDelegate = loginInspector
            }
            
            self.viewController = loginViewController
            
        }
    }
}
