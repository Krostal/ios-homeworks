
import UIKit

class FeedViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 10
    }
    
    private let feedViewModel: FeedViewModel
    private let firstNavigationController: UINavigationController
    private var feedView: FeedView?
    
    
    init(viewModel: FeedViewModel, firstNavigationController: UINavigationController) {
        self.feedViewModel = viewModel
        self.firstNavigationController = firstNavigationController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        feedView = FeedView(viewModel: feedViewModel, navigationControllerProtocol: self)
        if let feedView = feedView {
            view.addSubview(feedView)
            feedView.frame = view.bounds
        }
    }
    
}

extension FeedViewController: NavigationControllerProtocol {}
