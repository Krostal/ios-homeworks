import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func startApp() -> UITabBarController
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

final class MainCoordinator: MainCoordinatorProtocol {
    
    static let shared = MainCoordinator()
    
    private init() {
    }
    
    private lazy var tabBarControllerAuth: UITabBarController = {
        let tabBarController = UITabBarController()
        
        let feedNavigationController = TabBarFactory(flow: .feedCoordinator).navigationController
        let loginNavigationController = TabBarFactory(flow: .loginCoordinator).navigationController
                
        tabBarController.viewControllers = [feedNavigationController, loginNavigationController]

        tabBarController.tabBar.tintColor = UIColor(named: "AccentColor")
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.selectedIndex = 1
        
        return tabBarController
        
    }()
    
    private lazy var tabBarControllerProfile: UITabBarController = {
        let tabBarController = UITabBarController()
        
        let feedNavigationController = TabBarFactory(flow: .feedCoordinator).navigationController
        let profileNavigationController = TabBarFactory(flow: .profileCoordinator).navigationController
        let favoritePostsNavigationController = TabBarFactory(flow: .favoritePostCoordinator).navigationController
        
        tabBarController.viewControllers = [feedNavigationController, profileNavigationController, favoritePostsNavigationController]

        tabBarController.tabBar.tintColor = UIColor(named: "AccentColor")
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.selectedIndex = 1
        
        return tabBarController
        
    }()
    
    func updateTabBarController() {
        let profileNavigationController = TabBarFactory(flow: .profileCoordinator).navigationController
        let favoritePostsNavigationController = TabBarFactory(flow: .favoritePostCoordinator).navigationController
        tabBarControllerAuth.viewControllers?[1] = profileNavigationController
        tabBarControllerAuth.viewControllers?.append(favoritePostsNavigationController)
    }
    
    
    func startApp() -> UITabBarController {
        
        if CheckerService.shared.isLogIn {
            return tabBarControllerProfile
        } else {
            return tabBarControllerAuth
        }
    }
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
