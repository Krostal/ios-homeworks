
import Foundation

final class FeedModel {
    
    let secretWord = "secret"
    
    func check(word: String, completion: @escaping (Result<String, SecretWordError>) -> Void) {
        
        if word == secretWord {
            completion(.success("Correct".localized + "!"))
        } else if word.isEmpty {
            completion(.failure(.isEmpty))
        } else {
            completion(.failure(.incorrect))
        }
    }
    
}

