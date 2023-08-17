
import UIKit

class FeedViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 10
    }
    
    var new: News = News(title: "My post")
    
    private lazy var firstButton: CustomButton = {
        CustomButton(
            title: "Open the news",
            backgroundColor: .systemBlue,
            tintColor: .white,
            setupButton: { button in
                button.clipsToBounds = true
                button.layer.cornerRadius = Constants.spacing
                button.configuration = UIButton.Configuration.plain()
                button.configuration?.contentInsets = NSDirectionalEdgeInsets(
                    top: Constants.spacing,
                    leading: Constants.spacing,
                    bottom: Constants.spacing,
                    trailing: Constants.spacing
                )
            },
            tapHandler: {
                self.showPostViewController()
            }
        )
    }()

    private lazy var secondButton: CustomButton = {
        CustomButton(
            title: "Show the news",
            backgroundColor: .systemBlue,
            tintColor: .white,
            setupButton: { button in
                button.clipsToBounds = true
                button.layer.cornerRadius = Constants.spacing
                button.configuration = UIButton.Configuration.plain()
                button.configuration?.contentInsets = NSDirectionalEdgeInsets(
                    top: Constants.spacing,
                    leading: Constants.spacing,
                    bottom: Constants.spacing,
                    trailing: Constants.spacing
                )
            },
            tapHandler: {
                self.showPostViewController()
            }
        )
    }()
    
//    private lazy var firstButton: UIButton = {
//        let firstButton = UIButton()
//        firstButton.setTitle("Open the news", for: .normal)
//        firstButton.backgroundColor = .systemBlue
//        firstButton.tintColor = .white
//        firstButton.clipsToBounds = true
//        firstButton.layer.cornerRadius = Constants.spacing
//        firstButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: Constants.spacing, leading: Constants.spacing, bottom: Constants.spacing, trailing: Constants.spacing)
//        firstButton.configuration = UIButton.Configuration.plain()
//        firstButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
//        return firstButton
//    }()
//
//    private lazy var secondButton: UIButton = {
//        let secondButton = UIButton()
//        secondButton.setTitle("Show the news", for: .normal)
//        secondButton.backgroundColor = .systemBlue
//        secondButton.tintColor = .white
//        secondButton.clipsToBounds = true
//        secondButton.layer.cornerRadius = Constants.spacing
//        secondButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: Constants.spacing, leading: Constants.spacing, bottom: Constants.spacing, trailing: Constants.spacing)
//        secondButton.configuration = UIButton.Configuration.plain()
//        secondButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
//        return secondButton
//    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
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
    
    private func showPostViewController() {
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
        postViewController.titleNews = new.title
    }
    
//    @objc func buttonPressed(_ sender: UIButton) {
//        let postViewController = PostViewController()
//        self.navigationController?.pushViewController(postViewController, animated: true)
//        postViewController.titleNews = new.title
//    }
    
}
