
import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func editButtonTapped()
    func postViewControllerDidDisappear(_ viewController: PostViewController)
}

class PostViewController: UIViewController {
    var titleNews: String = ""
    weak var delegatePostVC: PostViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        self.navigationItem.title = titleNews
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(barButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegatePostVC?.postViewControllerDidDisappear(self)
    }
    
    
    
    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        delegatePostVC?.editButtonTapped()
    }
}
