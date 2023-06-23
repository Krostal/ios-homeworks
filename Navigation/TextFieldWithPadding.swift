import UIKit

<<<<<<< HEAD
 class TextFieldWithPadding: UITextField {
     var textPadding = UIEdgeInsets(
         top: 0,
         left: 10,
         bottom: 0,
         right: 10
     )

     override func textRect(forBounds bounds: CGRect) -> CGRect {
         let rect = super.textRect(forBounds: bounds)
         return rect.inset(by: textPadding)
     }

     override func editingRect(forBounds bounds: CGRect) -> CGRect {
         let rect = super.editingRect(forBounds: bounds)
         return rect.inset(by: textPadding)
     }
 }

=======
class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 1,
        left: 10,
        bottom: 1,
        right: 10
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
>>>>>>> f9a8f95dad4867115f430c154502e92188bfbc98
