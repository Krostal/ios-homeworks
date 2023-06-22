
import UIKit

class FeedViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let activeButton = UIButton()
        activeButton.setTitle("Open the post", for: .normal)
        activeButton.setTitleColor(.darkText, for: .normal)
        activeButton.backgroundColor = .systemIndigo
        activeButton.translatesAutoresizingMaskIntoConstraints = false
        return activeButton
    }()
    
    var post: Post = Post(title: "My post")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        setupUI()
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 30
            ),
            button.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -30
            ),
            button.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])

    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
        postViewController.titlePost = post.title
    }
    
}
