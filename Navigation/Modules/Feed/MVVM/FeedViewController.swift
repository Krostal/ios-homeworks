
import UIKit

class FeedViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 10
    }
    
    var new: News = News(title: "My post")
    
    private let feedViewModel = FeedViewModel()
    
    private lazy var firstButton = CustomButton(
        title: "Open the news",
        cornerRadius: Constants.spacing,
        action: { [ weak self ] in
            self?.showPostViewController()
        }
    )
    
    private lazy var secondButton = CustomButton(
        title: "Show the news",
        cornerRadius: Constants.spacing,
        action: { [ weak self ] in
            self?.showPostViewController()
        }
    )
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter the secret word (hint: \"пароль\")"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        return textField
    }()
    
    private lazy var checkGuessButton = CustomButton(
        title: "Check Guess",
        backgroundColor: .systemGreen,
        cornerRadius: Constants.spacing,
        action: { [unowned self] in
            guard let word = textField.text else { return }
            feedViewModel.checkGuess(word: word)
        })
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    
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
        addSubviews()
        setupConstraints()
        feedViewModel.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        view.addSubview(textField)
        view.addSubview(checkGuessButton)
        view.addSubview(resultLabel)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            
            checkGuessButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            checkGuessButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 40),
            checkGuessButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            
            textField.bottomAnchor.constraint(equalTo: checkGuessButton.topAnchor, constant: -10),
            textField.widthAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.widthAnchor, multiplier: 0.9),
            textField.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            
            resultLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20),
            resultLabel.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
        ])
    }
    
    private func showPostViewController() {
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
        postViewController.titleNews = new.title
    }

}


extension FeedViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension FeedViewController: FeedViewModelDelegate {
    func didCheckGuess(_ isCorrect: Bool) {
        resultLabel.textColor = isCorrect ? .green : .systemRed
        resultLabel.text = isCorrect ? "Correct!" : "Incorrect!"
    }
}


