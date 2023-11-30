import UIKit

class CustomTextField: UITextField {
    
    private let textPadding = UIEdgeInsets(
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
    
    
    init(placeholder: String, fontSize: CGFloat) {
        super.init(frame: .zero)
        commonInit(placeholder: placeholder, fontSize: fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(placeholder: "", fontSize: 16)
    }
    
    private func commonInit(placeholder: String, fontSize: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = placeholder
        font = .systemFont(ofSize: fontSize, weight: .regular)
        textColor = ColorPalette.textColor
        backgroundColor = .systemGray6
        autocapitalizationType = .none
        autocorrectionType = .no
        keyboardType = .default
        returnKeyType = .done
        clearButtonMode = .whileEditing
        contentVerticalAlignment = .center
        adjustsFontSizeToFitWidth = true
        delegate = self
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


