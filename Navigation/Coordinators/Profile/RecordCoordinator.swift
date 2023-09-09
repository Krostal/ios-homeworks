import UIKit

protocol RecordCoordinatorDelegate: AnyObject {
    func recordCoordinatorDidFinish(_ coordinator: RecordCoordinator)
}

final class RecordCoordinator: Coordinator {
    
    weak var delegate: RecordCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let recordViewController = RecordViewController()
        recordViewController.delegate = self
        recordViewController.title = "My record studio"
        navigationController.pushViewController(recordViewController, animated: true)
    }
    
}

extension RecordCoordinator: RecordViewControllerDelegate {
    
    func recordViewControllerDidDisappear() {
        delegate?.recordCoordinatorDidFinish(self)
    }
}
