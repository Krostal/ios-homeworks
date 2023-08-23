import UIKit

protocol InfoCoordinatorDelegate: AnyObject {
    func infoCoordinatorDidFinish(_ coordinator: InfoCoordinator)
}

final class InfoCoordinator: Coordinator {
    
    weak var delegateInfoCoordinator: InfoCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let infoViewController = InfoViewController()
        infoViewController.infoDelegate = self
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
        navigationController.present(infoViewController, animated: true)
    }
    
}

extension InfoCoordinator: InfoViewControllerDelegate {
    func infoViewControllerDismissed() {
        delegateInfoCoordinator?.infoCoordinatorDidFinish(self)
    }
}



