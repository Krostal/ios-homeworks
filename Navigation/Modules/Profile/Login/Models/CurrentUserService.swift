
import Foundation

public final class CurrentUserService: UserService {
    
    private var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
    }
    
    func authorizeUser(login: String) throws -> User? {
        guard !currentUser.login.isEmpty else {
            throw LoginError.emptyUserName
        }
        guard currentUser.login == login else {
            throw LoginError.invalidUserName
        }
        
        return currentUser
    }
    
}