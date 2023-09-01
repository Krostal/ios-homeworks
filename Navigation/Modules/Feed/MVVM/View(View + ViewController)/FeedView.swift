import UIKit

class FeedView: UIView {
    
    private struct Constants {
        static let spacing: CGFloat = 10
    }
    
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
    
    private lazy var textField: CustomTextField = {
        let textField = CustomTextField(
            placeholder: "Enter the secret word (hint: \"secret\")",
            fontSize: 17
        )
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var checkGuessButton = CustomButton(
        title: "Check Guess",
        backgroundColor: .systemGreen,
        cornerRadius: Constants.spacing,
        action: { [weak self] in
            guard let self,
                  let word = self.textField.text else { return }
            self.viewModel.validateSecretWord(word: word) {message  in
                DispatchQueue.main.async {
                    self.resultLabel.text = message
                    self.resultLabel.textColor = message == "Correct!" ? .green : .red
                }
            }
        })
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        return stackView
    }()
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(stackView)
        addSubview(textField)
        addSubview(checkGuessButton)
        addSubview(resultLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            
            checkGuessButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            checkGuessButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            checkGuessButton.heightAnchor.constraint(equalToConstant: 40),
            checkGuessButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            textField.bottomAnchor.constraint(equalTo: checkGuessButton.topAnchor, constant: -10),
            textField.widthAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            textField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            resultLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20),
            resultLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    private func showPostViewController() {
        viewModel.buttonTapped()
    }
}

