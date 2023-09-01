
import Foundation

public final class TestUserService: UserService {
    
    private var testUser: User?
    
    init(testUser: User) {
        self.testUser = testUser
    }
    
    func authorizeUser(login: String) throws -> User? {
        
        guard let testUser = testUser else {
            throw LoginError.unauthorized
        }
        
        guard testUser.login == login else {
            throw LoginError.invalidUserName
        }
        
        return testUser
    }
}
