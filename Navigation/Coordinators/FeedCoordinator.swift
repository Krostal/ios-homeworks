
import UIKit

final class FeedCoordinator {
    
    private let new: News = News(title: "My post")
    
    var navigationController: UINavigationController?
    
    init() {
        navigationController = UINavigationController() 
    }
    
    func start() -> UINavigationController {
        let feedModel = FeedModel()
        let feedViewModel = FeedViewModel(model: feedModel, coordinator: self)
        let feedViewController = FeedViewController(viewModel: feedViewModel)
                
        navigationController?.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "doc.richtext"), tag: 0)
        navigationController?.setViewControllers([feedViewController], animated: true)
        
        return navigationController!
    }
    
    func showDetails() {
        let postViewController = PostViewController()
        postViewController.titleNews = new.title
        
        navigationController?.pushViewController(postViewController, animated: true)
    }
}


