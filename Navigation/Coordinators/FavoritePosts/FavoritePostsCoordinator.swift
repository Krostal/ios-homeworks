
import UIKit

final class FavoritePostsCoordinator: Coordinator {
    
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let favoritePostsViewController = FavoritePostsViewController()
        navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 2)
        navigationController.setViewControllers([favoritePostsViewController], animated: true)
    }
}
