import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func startApp() -> UIViewController
}

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
}

final class MainCoordinator: MainCoordinatorProtocol {
    
    private lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        
        let feedNavigationController = TabBarFactory(flow: .feedCoordinator).navigationController
        let loginNavigationController = TabBarFactory(flow: .loginCoordinator).navigationController
        tabBarController.viewControllers = [feedNavigationController, loginNavigationController]

        tabBarController.tabBar.tintColor = UIColor(named: "AccentColor")
        tabBarController.tabBar.backgroundColor = .systemGray6
        return tabBarController
        
    }()
    
    func startApp() -> UIViewController {
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

