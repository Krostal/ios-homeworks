
import Foundation

final class FeedViewModel {

    private let feedModel: FeedModel
    private let feedCoordinator: FeedCoordinator
    
    var validationResultChanged: ((Bool, String) -> Void)?
    

    init(model: FeedModel, coordinator: FeedCoordinator) {
        self.feedModel = model
        self.feedCoordinator = coordinator
    }

    func validateSecretWord(word: String) {
        let isValid = feedModel.check(word: word)
        let validationResultText = isValid ? "Сorrect!" : "Incorrect!"
        validationResultChanged?(isValid, validationResultText)
    }
    
    func buttonTapped() {
        feedCoordinator.showDetails()
    }

}
