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
            let feedCoordinator = FeedCoordinator(navigationController: navigationController)
            feedCoordinator.start()
            viewController = navigationController.viewControllers.first
            
        case .loginCoordinator:
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            loginCoordinator.start()
            viewController = navigationController.viewControllers.first
        }
    }
}

