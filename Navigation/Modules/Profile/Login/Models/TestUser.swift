
import Foundation

public final class TestUserService: UserService {
    
    private var testUser: User?
    
    init(testUser: User) {
        self.testUser = testUser
    }
    
    func authorizeUser(login: String) -> User? {
        testUser?.login == login ? testUser : nil
    }
}
