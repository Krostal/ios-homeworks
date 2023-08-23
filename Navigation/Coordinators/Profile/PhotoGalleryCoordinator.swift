
import UIKit

protocol PhotoGalleryCoordinatorDelegate: AnyObject {
    func photoGalleryCoordinatorDidFinish(_ coordinator: PhotoGalleryCoordinator)
}

final class PhotoGalleryCoordinator: Coordinator {
    
    weak var delegate: PhotoGalleryCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let photoGalleryViewController = PhotoGalleryViewController()
        photoGalleryViewController.delegate = self
        photoGalleryViewController.title = "Photo Gallery"
        navigationController.pushViewController(photoGalleryViewController, animated: true)
    }
}

extension PhotoGalleryCoordinator: PhotoGalleryViewControllerDelegate {
    func photoGalleryViewControllerDidDisappear() {
        delegate?.photoGalleryCoordinatorDidFinish(self)
    }
    
    
}
