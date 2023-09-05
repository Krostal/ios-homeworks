import UIKit

protocol MusicCoordinatorDelegate: AnyObject {
    func musicCoordinatorDidFinish(_ coordinator: MusicCoordinator)
}

final class MusicCoordinator: Coordinator {
    
    weak var delegate: MusicCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let musicViewController = MusicViewController()
        musicViewController.delegate = self
        musicViewController.title = "My music"
        navigationController.pushViewController(musicViewController, animated: true)
    }
}

extension MusicCoordinator: MusicViewControllerDelegate {
    func musicViewControllerDidDisappear() {
        delegate?.musicCoordinatorDidFinish(self)
    }
}
