
import Foundation

public final class TestUserService: UserService {
    
    private var testUser: User
    
    init(testUser: User) {
        self.testUser = testUser
    }
    
    func authorizeUser(login: String) throws -> User? {
        guard !testUser.login.isEmpty else {
            throw LoginError.emptyUserName
        }
        guard testUser.login == login else {
            throw LoginError.invalidUserName
        }
        return testUser
    }
}
