
@testable import Navigation
import XCTest

enum ValidationMessage: String {
    case correct = "Correct!"
    case isEmpty = "Please enter the secret word"
    case incorrect = "Incorrect!"
}

final class FeedViewModelTests: XCTestCase {
    
    var feedModelMock: FeedModelMock!
    var feedViewModelMock: FeedViewModelMock!
    
    var resultMessage: String?
    
    override func setUp() {
        super.setUp()
        feedModelMock = FeedModelMock()
        feedViewModelMock = FeedViewModelMock(model: feedModelMock)
    }
    
    override func tearDown() {
        feedModelMock = nil
        feedViewModelMock = nil
        super.tearDown()
    }
    
    func testCorrectWord() {
        feedModelMock.fakeResult = .success("Correct!")
        
        feedViewModelMock.validateSecretWord(word: "secret") { message in
            self.resultMessage = message
        }
        
        XCTAssertEqual(resultMessage?.localized, ValidationMessage.correct.rawValue, "The message should be " + ValidationMessage.correct.rawValue)
    }
    
    func testEmptyWord() {
        feedModelMock.fakeResult = .failure(.isEmpty)
        feedViewModelMock.validateSecretWord(word: "") { message in
            self.resultMessage = message
        }
        
        XCTAssertEqual(resultMessage, ValidationMessage.isEmpty.rawValue, "The message should be " + ValidationMessage.isEmpty.rawValue)
    }
    
    func testIncorrectWord() {
        feedModelMock.fakeResult = .failure(.incorrect)
        feedViewModelMock.validateSecretWord(word: "wrong") { message in
            self.resultMessage = message
        }
        XCTAssertEqual(resultMessage, ValidationMessage.incorrect.rawValue, "The message should be " + ValidationMessage.incorrect.rawValue)
    }
}
