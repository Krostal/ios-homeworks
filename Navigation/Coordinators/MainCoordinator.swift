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
    
    private lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        
        let feedNavigationController = TabBarFactory(flow: .feedCoordinator).navigationController
        let loginNavigationController = TabBarFactory(flow: .loginCoordinator).navigationController
        
        var viewControllers: [UIViewController] = [feedNavigationController, loginNavigationController]
        
        if CheckerService.shared.isLogIn {
            let favoritePostsNavigationController = TabBarFactory(flow: .favoritePostCoordinator).navigationController
            viewControllers.append(favoritePostsNavigationController)
        }
        
        tabBarController.viewControllers = viewControllers

        tabBarController.tabBar.tintColor = UIColor(named: "AccentColor")
        tabBarController.tabBar.backgroundColor = .systemGray6
        tabBarController.selectedIndex = 1
        
        return tabBarController
        
    }()
    
    func updateTabBarController() {
        let favoritePostsNavigationController = TabBarFactory(flow: .favoritePostCoordinator).navigationController
        tabBarController.viewControllers?.append(favoritePostsNavigationController)
//        tabBarController.viewControllers?.removeAll()
//        let feedNavigationController = TabBarFactory(flow: .feedCoordinator).navigationController
//        let loginNavigationController = TabBarFactory(flow: .loginCoordinator).navigationController
//        let favoritePostsNavigationController = TabBarFactory(flow: .favoritePostCoordinator).navigationController
//        let viewControllers: [UIViewController] = [feedNavigationController, loginNavigationController, favoritePostsNavigationController]
//        tabBarController.viewControllers = viewControllers
//        tabBarController.selectedIndex = 1
    }
    
    
    func startApp() -> UITabBarController {
        return tabBarController
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
