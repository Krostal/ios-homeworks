import UIKit

final class TabBarFactory {
    enum Flow {
        case feedCoordinator
        case loginCoordinator
        case favoritePostCoordinator
    }
    
    private let flow: Flow
    private(set) var viewController: UIViewController?
    private(set) var navigationController = UINavigationController()
    private(set) var postTitle: String?
    
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
        case .favoritePostCoordinator:
            let favoritePostsCoordinator = FavoritePostsCoordinator(navigationController: navigationController)
            favoritePostsCoordinator.start()
            viewController = navigationController.viewControllers.first
        }
    }
}

