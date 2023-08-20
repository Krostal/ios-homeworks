
import UIKit

final class MainTabBarController: UITabBarController {
    
    var feedCoordinator: FeedCoordinator?
    
    private let feedVC = Factory(flow: .feedCoordinator)
    private let loginVC = Factory(flow: .loginCoordinator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
    }
    
    private func setControllers() {
        viewControllers = [feedVC.navigationController, loginVC.navigationController]
        view.tintColor = UIColor(named: "AccentColor")
    }
}


