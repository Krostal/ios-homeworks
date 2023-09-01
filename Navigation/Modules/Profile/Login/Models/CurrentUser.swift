
import Foundation

public final class CurrentUserService: UserService {
    
    private var currentUser: User?
    
    init(currentUser: User) {
        self.currentUser = currentUser
    }
    
    func authorizeUser(login: String) -> User? {
        currentUser?.login == login ? currentUser : nil
    }
    
}
