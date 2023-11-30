import UIKit

public class CustomButton: UIButton {
    
    typealias Action = () -> Void
    
    private var buttonAction: Action
    
    private var setupButton: ((CustomButton) -> Void)?
    
    init(
        title: String,
        backgroundColor: UIColor = UIColor(named: "AccentColor") ?? .systemBlue,
        cornerRadius: CGFloat = 0,
        setupButton: ((CustomButton) -> Void)? = nil,
        action: @escaping Action
    ) {
        buttonAction = action
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(ColorPalette.textColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = ColorPalette.textColor
        self.setupButton = setupButton
        
        configureButton()
        
        layer.cornerRadius = cornerRadius

        translatesAutoresizingMaskIntoConstraints = false
        configuration = UIButton.Configuration.plain()
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        setupButton?(self)
    }
    
    @objc private func buttonTapped() {
        buttonAction()
    }
}
