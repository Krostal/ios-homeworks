

@testable import Navigation
import XCTest

class FeedModelMock: FeedModelProtocol {
    
    var fakeResult:  Result<String, SecretWordError>!
    
    func check(word: String, completion: @escaping (Result<String, SecretWordError>) -> Void) {
        completion(fakeResult)
    }
}
