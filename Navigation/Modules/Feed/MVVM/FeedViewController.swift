
import UIKit

class FeedViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 10
    }
    
    private let new: News = News(title: "My post")
    
    private let viewModel: FeedViewModel
    
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
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        return textField
    }()
    
    private lazy var checkGuessButton = CustomButton(
        title: "Check Guess",
        backgroundColor: .systemGreen,
        cornerRadius: Constants.spacing,
        action: { [weak self] in
            guard let word = self?.textField.text else { return }
            self?.viewModel.validateSecretWord(word: word)
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
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        addSubviews()
        setupConstraints()
        bindViewModel()
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
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] newState in
            self?.resultLabel.text = newState == .valid ? "Correct!" : "Incorrect!"
            self?.resultLabel.textColor = newState == .valid ? .green : .red
        }
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


