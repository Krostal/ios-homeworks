import UIKit

final class TabBarFactory {
    enum Flow {
        case feedCoordinator
        case loginCoordinator
        case profileCoordinator
        case favoritePostCoordinator
    }
    
    private let flow: Flow
    private var user: UserModel?
    private(set) var viewController: UIViewController?
    private(set) var navigationController = UINavigationController()
    private(set) var postTitle: String?

    
    init(flow: Flow, user: UserModel? = nil) {
        self.flow = flow
        self.user = CheckerService.shared.currentUser
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
        case .profileCoordinator:
            let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
            if let user = user { 
                profileCoordinator.start(forUser: user)
            } else {
                fatalError("CheckerService.shared.currentUser is not exist")
            }
            viewController = navigationController.viewControllers.first
        }
    }
}

