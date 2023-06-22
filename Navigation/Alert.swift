
import UIKit

struct Alert {
    static let titleAlert = "Attention!"
    static let messageAlert = "Are you sure you want to delete this post?"
    
    private static func showAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            print("Post successfully deleted")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            print("Deletion canceled")
        }))
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
        
}

    static func showAlert(on vc: UIViewController) {
        showAlert(on: vc, with: titleAlert, message: messageAlert)
    }
}
