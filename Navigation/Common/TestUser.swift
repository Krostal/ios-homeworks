
import UIKit

let testUser = User(login: "TestUser", fullName: "TestUser", avatar: UIImage(systemName: "person.fill.questionmark"), status: "Test is done")

public final class TestUserService: UserService {
    
    private var testUser: User?
    
    init(testUser: User) {
        self.testUser = testUser
    }
    
    func authorizeUser(login: String) -> User? {
        if let testUser = testUser, testUser.login == login {
            return testUser
        } else {
            return nil
        }
    }
}
