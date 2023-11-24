

@testable import Navigation
import XCTest

final class FeedViewModelMock {
    
    private let feedModel: FeedModelProtocol
    
    init(model: FeedModelProtocol) {
        self.feedModel = model
    }
    
    func validateSecretWord(word: String, completion: @escaping (String) -> Void) {
        var message: String = ""
        
        feedModel.check(word: word) { result in
            switch result {
            case .success(let successMessage):
                message = successMessage
            case .failure(let error):
                switch error {
                case .isEmpty:
                    message = "Please enter the secret word"
                case .incorrect:
                    message = "Incorrect".localized + "!"
                }
            }
            completion(message)
        }
    }
}
