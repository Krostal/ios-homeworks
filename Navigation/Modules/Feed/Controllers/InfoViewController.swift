
import UIKit

class InfoViewController: UIViewController {
    
    private enum Constants {
        static let spacing: CGFloat = 50
    }
    
    private lazy var buttonDelete: CustomButton = {
        CustomButton(
            title: "Delete this new",
            backgroundColor: .systemCyan,
            tintColor: .white,
            tapHandler: {
                Alert.showAlert(on: self)
            }
        )
    }()
    
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

}
