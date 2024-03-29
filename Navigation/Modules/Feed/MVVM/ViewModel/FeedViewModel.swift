
import Foundation

final class FeedViewModel {
    
    private let feedModel: FeedModelProtocol
    private let feedCoordinator: FeedCoordinatorProtocol
    
    init(model: FeedModelProtocol, coordinator: FeedCoordinatorProtocol) {
        self.feedModel = model
        self.feedCoordinator = coordinator
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
    
    func buttonTapped() {
        feedCoordinator.showPost()
    }

}
