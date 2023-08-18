
import Foundation

final class FeedViewModel {
    
    private var feedModel = FeedModel()
    
    weak var delegate: FeedViewModelDelegate?
    
    func checkGuess(word: String) {
        let isCorrect = feedModel.check(word: word)
        delegate?.didCheckGuess(isCorrect)
        
    }
}

protocol FeedViewModelDelegate: AnyObject {
    func didCheckGuess(_ isCorrect: Bool)
}

