
import UIKit

class InfoViewController: UIViewController {
    
    private enum Constants {
        static let spacing: CGFloat = 50
    }
    
    private lazy var buttonDelete = CustomButton(
            title: "Delete this new",
            backgroundColor: .systemCyan,
            action: { [weak self] in
                self?.showAlert()
            })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(buttonDelete)
        
        NSLayoutConstraint.activate([
            buttonDelete.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.spacing
            ),
            buttonDelete.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.spacing
            ),
            buttonDelete.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerYAnchor
            ),
            buttonDelete.heightAnchor.constraint(equalToConstant: Constants.spacing)
        ])

    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Attention!",
            message: "Are you sure you want to delete this new?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            print("The new successfully deleted")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Deletion canceled")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}
