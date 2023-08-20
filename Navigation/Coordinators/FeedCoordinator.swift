
import UIKit

final class FeedCoordinator {
    
    var navigationController: UINavigationController?
    
    func showDetails() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}


