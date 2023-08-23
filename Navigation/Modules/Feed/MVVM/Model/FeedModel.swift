
import Foundation

final class FeedModel {
    
    // Секретное слово, которое будет сравниваться с введенным словом
    let secretWord = "пароль"
    
    // Метод для проверки введенного слова
    func check(word: String) -> Bool {
        let isCorrect = word == secretWord
        return isCorrect
    }
    
}

