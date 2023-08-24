
import UIKit

final class FeedCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    private let postTitle: News = News(title: "My Post")
    
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let feedModel = FeedModel()
        let feedViewModel = FeedViewModel(model: feedModel, coordinator: self)
        let feedViewController = FeedViewController(viewModel: feedViewModel)

        navigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "doc.richtext"), tag: 0)
        navigationController.setViewControllers([feedViewController], animated: true)
    }

    func showPost() {
        let postCoordinator = PostCoordinator(navigationController: navigationController, postTitle: postTitle.title)
        postCoordinator.delegatePostCoordinator = self
        addChildCoordinator(postCoordinator)
        postCoordinator.start()
    }
}

extension FeedCoordinator: PostCoordinatorDelegate {
    func postCoordinatorDidFinish(_ coordinator: PostCoordinator) {
        if coordinator.childCoordinators.isEmpty {
            removeChildCoordinator(coordinator)
        }
    }
}
