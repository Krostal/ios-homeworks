
import Foundation

final class FeedViewModel {
    
    enum State {
        case valid
        case invalid
    }

    private let feedModel: FeedModel
    private let feedCoordinator: FeedCoordinator
    var stateChanged: ((State) -> Void)?

    init(model: FeedModel, coordinator: FeedCoordinator) {
        self.feedModel = model
        self.feedCoordinator = coordinator
    }

    func validateSecretWord(word: String) {
        let isValid = feedModel.check(word: word)
        let newState: State = isValid ? .valid : .invalid
        stateChanged?(newState)
    }
    
    func buttonTapped() {
        feedCoordinator.showDetails()
    }

}
