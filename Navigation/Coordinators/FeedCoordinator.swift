
import UIKit

final class FeedCoordinator {
    
    private let new: News = News(title: "My post")
    
    var navigationController: UINavigationController?
    
    func showDetails() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
        postViewController.titleNews = new.title
    }
}


