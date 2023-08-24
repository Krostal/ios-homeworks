
import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func profileCoordinatorDidFinished(_ coordinator: ProfileCoordinator)
}

final class ProfileCoordinator: Coordinator {
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        fatalError("ProfileCoordinator requires a user to start.")
    }

    func start(forUser user: User) {
        let profileViewController = ProfileViewController()
        profileViewController.delegate = self
        profileViewController.currentUser = user
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func showPhotoGallery() {
        let photoGalleryCoordinator = PhotoGalleryCoordinator(navigationController: navigationController)
        photoGalleryCoordinator.delegate = self
        addChildCoordinator(photoGalleryCoordinator)
        print(childCoordinators)
        photoGalleryCoordinator.start()
    }
    
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    func showPhotoGalleryViewController() {
        showPhotoGallery()
    }
    
    func profileViewControllerDidDisappear() {
        delegate?.profileCoordinatorDidFinished(self)
    }
}

extension ProfileCoordinator: PhotoGalleryCoordinatorDelegate {
    func photoGalleryCoordinatorDidFinish(_ coordinator: PhotoGalleryCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
