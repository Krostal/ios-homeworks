import UIKit

final class TabBarFactory {
    enum Flow {
        case feedCoordinator
        case loginCoordinator
        case profileCoordinator(UserModel)
    }
    
    private let flow: Flow
    private(set) var viewController: UIViewController?
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
            let loginCoordinator = LoginCoordinator(navigationController: navigationController, checkerService: CheckerService.shared)
            loginCoordinator.start()
            viewController = navigationController.viewControllers.first
        case .profileCoordinator(let user):
            let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
            profileCoordinator.start(forUser: user)
            viewController = navigationController.viewControllers.first
        }
    }
}

