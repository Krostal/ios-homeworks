import UIKit

protocol Coordinator: AnyObject {
    func startApp() -> UIViewController
}

class MainCoordinator: Coordinator {
    func startApp() -> UIViewController {
        return MainTabBarController()
    }
}
