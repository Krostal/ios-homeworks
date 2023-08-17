import UIKit

public class CustomButton: UIButton {
    
    private var tapHandler: (() -> Void)? // замыкание, которое будет вызвано при нажатии на кнопку
    private var setupButton: ((CustomButton) -> Void)? // замыкание, которое позволяет настроить внешний вид и свойства кнопки. Оно принимает в качестве параметра саму кнопку CustomButton.
    
    init(
        title: String, // текст, который будет отображаться на кнопке
        backgroundColor: UIColor, // цвет фона кнопки
        tintColor: UIColor, // цвет текста и значка на кнопке
        setupButton: ((CustomButton) -> Void)? = nil, // замыкание для настройки внешнего вида кнопки (по умолчанию nil)
        tapHandler: (() -> Void)? // замыкание, которое будет вызвано при нажатии на кнопку.
    ) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.darkText, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        
        self.tapHandler = tapHandler
        self.setupButton = setupButton
        configureButton()
        
        translatesAutoresizingMaskIntoConstraints = false // отключаем автоматическую генерацию ограничений на основе фрейма для установки констрейнтов вручную
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside) // фиксируем действие кнопки
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // приватный метод, который вызывает переданное замыкание setupButton, если оно было передано, и передает ему текущий экземпляр CustomButton.
    private func configureButton() {
        setupButton?(self)
    }
    
    // метод, который вызывается при нажатии на кнопку. Он запускает переданное замыкание tapHandler, если оно было передано.
    @objc private func buttonTapped() {
        tapHandler?()
    }
}

