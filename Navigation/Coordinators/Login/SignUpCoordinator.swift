import UIKit

protocol SignUpCoordinatorDelegate: AnyObject {
    func signUpCoordinatorDidFinish(_ coordinator: SignUpCoordinator)
}

final class SignUpCoordinator: Coordinator {
    
    weak var delegate: SignUpCoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signUpViewController = SignUpViewController()
        signUpViewController.delegate = self
        signUpViewController.title = "Sign Up"
        navigationController.present(signUpViewController, animated: true)
    }
}

extension SignUpCoordinator: SignUpViewControllerDelegate {
    func signUpViewControllerDidDisappear() {
        delegate?.signUpCoordinatorDidFinish(self)
    }
}
