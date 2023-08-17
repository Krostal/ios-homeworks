
import Foundation

protocol FeedModelDelegate: AnyObject {
    
    // определяем метод, который будет вызываться, когда будет выполнена проверка введенного слова
    func didCheckGuess(_ isCorrect: Bool)
}

public final class FeedModel {
    
    // Слабая ссылка на объект, который будет выступать в роли делегата
    weak var delegate: FeedModelDelegate?
    
    // Секретное слово, которое будет сравниваться с введенным словом
    let secretWord = "пароль"
    
    // Метод для проверки введенного слова
    func check(word: String) {
        
        // Сравниваем введенное слово с загаданным
        let isCorrect = word == secretWord
        
        // Вызываем метод делегата и передаем ему результат проверки
        delegate?.didCheckGuess(isCorrect)
    }
    
}
