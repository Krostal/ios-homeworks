
import UIKit

protocol FavoritePostCoordinatorProtocol: AnyObject {
    func favoritePostCoordinatorDidFinished(_ coordinator: ProfileCoordinator)
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

    func start(forUser user: UserModel) {
        let profileViewController = ProfileViewController()
        profileViewController.currentUser = user
        profileViewController.delegate = self
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func showPhotoGallery() {
        let photoGalleryCoordinator = PhotoGalleryCoordinator(navigationController: navigationController)
        photoGalleryCoordinator.delegate = self
        addChildCoordinator(photoGalleryCoordinator)
        photoGalleryCoordinator.start()
    }
    
    func showAudioPlayer() {
        let musicCoordinator = MusicCoordinator(navigationController: navigationController)
        musicCoordinator.delegate = self
        addChildCoordinator(musicCoordinator)
        musicCoordinator.start()
    }
    
    func showVideoController() {
        let videoCoordinator = VideoCoordinator(navigationController: navigationController)
        videoCoordinator.delegate = self
        addChildCoordinator(videoCoordinator)
        videoCoordinator.start()
    }
    
    func showRecordView() {
        let recordCoordinator = RecordCoordinator(navigationController: navigationController)
        recordCoordinator.delegate = self
        addChildCoordinator(recordCoordinator)
        recordCoordinator.start()
    }
    
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    func showPhotoGalleryViewController() {
        showPhotoGallery()
    }
    
    func showMusicViewController() {
        showAudioPlayer()
    }
    
    func showVideoViewController() {
        showVideoController()
    }
    
    func showRecordViewController() {
        showRecordView()
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

extension ProfileCoordinator: MusicCoordinatorDelegate {
    func musicCoordinatorDidFinish(_ coordinator: MusicCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension ProfileCoordinator: VideoCoordinatorDelegate {
    func videoCoordinatorDidFinish(_ coordinator: VideoCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension ProfileCoordinator: RecordCoordinatorDelegate {
    func recordCoordinatorDidFinish(_ coordinator: RecordCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

