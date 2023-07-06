
import UIKit

class FeedViewController: UIViewController {
    
    var new: News = News(title: "My post")
    
    private lazy var firstButton: UIButton = {
        let firstButton = UIButton()
        firstButton.setTitle("Open the news", for: .normal)
        firstButton.backgroundColor = .systemBlue
        firstButton.tintColor = .white
        firstButton.clipsToBounds = true
        firstButton.layer.cornerRadius = 10
        firstButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        firstButton.configuration = UIButton.Configuration.plain()
        firstButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return firstButton
    }()
    
    private lazy var secondButton: UIButton = {
        let secondButton = UIButton()
        secondButton.setTitle("Show the news", for: .normal)
        secondButton.backgroundColor = .systemBlue
        secondButton.tintColor = .white
        secondButton.clipsToBounds = true
        secondButton.layer.cornerRadius = 10
        secondButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        secondButton.configuration = UIButton.Configuration.plain()
        secondButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return secondButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.safeAreaLayoutGuide.owningView?.backgroundColor = .lightGray
        setupConstraints()
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
        ])
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
        postViewController.titleNews = new.title
    }
    
}
