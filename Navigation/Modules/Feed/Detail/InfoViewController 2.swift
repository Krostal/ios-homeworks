
import UIKit

class InfoViewController: UIViewController {

    private lazy var buttonDelete: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("Delete this new", for: .normal)
        deleteButton.setTitleColor(.darkText, for: .normal)
        deleteButton.backgroundColor = .systemCyan
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        setupUI()
        buttonDelete.addTarget(self, action: #selector(pressDelete(_:)), for: .touchDown)

    }
    
    private func setupUI() {
        view.addSubview(buttonDelete)
        
        NSLayoutConstraint.activate([
            buttonDelete.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 50
            ),
            buttonDelete.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -50
            ),
            buttonDelete.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            buttonDelete.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    @objc func pressDelete(_ sender: UIButton) {
        
        Alert.showAlert(on: self)
    }

}
