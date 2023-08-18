import UIKit

public class CustomButton: UIButton {
    
    typealias Action = () -> Void
    
    private var buttonAction: Action
    
    private var setupButton: ((CustomButton) -> Void)?
    
    init(
        title: String,
        backgroundColor: UIColor = UIColor(named: "AccentColor") ?? .systemBlue,
        tintColor: UIColor = .white,
        cornerRadius: CGFloat = 0,
        setupButton: ((CustomButton) -> Void)? = nil,
        action: @escaping Action
    ) {
        buttonAction = action
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.darkText, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.setupButton = setupButton
        
        configureButton()
        
        layer.cornerRadius = cornerRadius // Устанавливаем cornerRadius после setupButton

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





//import UIKit
//
//public class CustomButton: UIButton {
//
//    // Тип для замыкания, представляющего действие кнопки
//    typealias Action = () -> Void
//
//    // Замыкание для выполнения действия при нажатии на кнопку
//    var buttonAction: Action
//
//    // Приватные свойства для замыканий
//    private var tapHandler: (() -> Void)?
//    private var setupButton: ((CustomButton) -> Void)?
//
//    // Инициализатор кнопки
//    init(
//        title: String,
//        backgroundColor: UIColor,
//        tintColor: UIColor,
//        setupButton: ((CustomButton) -> Void)? = nil,
//        action: @escaping Action
//    ) {
//        buttonAction = action
//        super.init(frame: .zero)
//
//        // Настройка внешнего вида кнопки
//        setTitle(title, for: .normal)
//        setTitleColor(.darkText, for: .normal)
//        self.backgroundColor = backgroundColor
//        self.tintColor = tintColor
//
//        // Привязка замыканий и настройка кнопки
//        self.setupButton = setupButton
//        configureButton()
//
//        // Отключение автоматически создаваемых ограничений и добавление действия для кнопки
//        translatesAutoresizingMaskIntoConstraints = false
//        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // Вызов переданного замыкания для настройки внешнего вида кнопки
//    private func configureButton() {
//        setupButton?(self)
//    }
//
//    // Обработчик нажатия на кнопку, вызывающий замыкание buttonAction
//    @objc private func buttonTapped() {
//        buttonAction()
//    }
//}


