
import UIKit

class FeedViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 10
    }
    
    private let feedViewModel: FeedViewModel

    private var feedView: FeedView?
    
    init(viewModel: FeedViewModel) {
        self.feedViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        feedView = FeedView(viewModel: feedViewModel)

        if let feedView = feedView {
            view.addSubview(feedView)
            feedView.frame = view.bounds
        }
    }
    
}


