import UIKit

protocol VideoCoordinatorDelegate: AnyObject {
    func videoCoordinatorDidFinish(_ coordinator: VideoCoordinator)
}

final class VideoCoordinator: Coordinator {
    
    weak var delegate: VideoCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let videoViewController = VideoViewController()
        videoViewController.delegate = self
        videoViewController.title = "My video"
        navigationController.pushViewController(videoViewController, animated: true)
    }
    
}

extension VideoCoordinator: VideoViewControllerDelegate {
    
    func videoViewControllerDidDisappear() {
        delegate?.videoCoordinatorDidFinish(self)
    }
}
