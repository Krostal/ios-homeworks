
import Foundation

final class FeedViewModel {
    
    enum State {
        case valid
        case invalid
    }

    private let model: FeedModel
    var stateChanged: ((State) -> Void)?

    init(model: FeedModel) {
        self.model = model
    }

    func validateSecretWord(word: String) {
        let isValid = model.check(word: word)
        let newState: State = isValid ? .valid : .invalid
        stateChanged?(newState)
    }
}
