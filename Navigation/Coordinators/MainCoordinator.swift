import UIKit

protocol Coordinator: AnyObject {
    func startApp() -> UIViewController
}

class MainCoordinator: Coordinator {
    
    private lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        
        let feedNavigationController = Factory(flow: .feedCoordinator).navigationController
        let loginNavigationController = Factory(flow: .loginCoordinator).navigationController
        tabBarController.viewControllers = [feedNavigationController, loginNavigationController]
        tabBarController.tabBar.tintColor = UIColor(named: "AccentColor")
        return tabBarController
    }()
    
    func startApp() -> UIViewController {
        return tabBarController
    }
}

