

import UIKit

final class MapCoordinator: Coordinator {
    
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapViewController = MapViewController()
        navigationController.tabBarItem = UITabBarItem(title: "Map".localized, image: UIImage(systemName: "mappin.and.ellipse.circle"), tag: 3)
        navigationController.setViewControllers([mapViewController], animated: true)
    }
}
