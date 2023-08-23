import UIKit

protocol PostCoordinatorDelegate: AnyObject {
    func postCoordinatorDidFinish(_ coordinator: PostCoordinator)
}

final class PostCoordinator: Coordinator {
    
    weak var delegatePostCoordinator: PostCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
        
    private let navigationController: UINavigationController
    private let postTitle: String
    
    init(navigationController: UINavigationController, postTitle: String) {
        self.navigationController = navigationController
        self.postTitle = postTitle
    }

    func start() {
        let postViewController = PostViewController()
        postViewController.titleNews = postTitle
        postViewController.delegatePostVC = self
        navigationController.pushViewController(postViewController, animated: true)
        
        
    }
    
    func showInfo() {
        let infoCoordinator = InfoCoordinator(navigationController: navigationController)
        infoCoordinator.delegateInfoCoordinator = self
        addChildCoordinator(infoCoordinator)
        infoCoordinator.start()
    }

}

extension PostCoordinator: PostViewControllerDelegate {
    
    func editButtonTapped() {
        showInfo()
    }
    
    func postViewControllerDidDisappear(_ viewController: PostViewController) {
        delegatePostCoordinator?.postCoordinatorDidFinish(self)
    }
}

extension PostCoordinator: InfoCoordinatorDelegate {
    func infoCoordinatorDidFinish(_ coordinator: InfoCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
