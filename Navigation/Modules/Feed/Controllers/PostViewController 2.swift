
import UIKit

class PostViewController: UIViewController {
    
    var titleNews: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        self.navigationItem.title = titleNews
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = .black
        
        let barButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(barButtonItemTapped(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    
    @objc func barButtonItemTapped(_ sender: UIBarButtonItem) {
        let infoViewController = InfoViewController()
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
        present(infoViewController, animated: true)
    }

}
