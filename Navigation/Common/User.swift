import UIKit

protocol UserService {
    func authorizeUser(login: String) -> User?
}

public final class User {
    public var login: String
    public var fullName: String
    public var avatar: UIImage?
    public var status: String
    
    init(login: String, fullName: String, avatar: UIImage?, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

let groot = User(login: "Groot", fullName: "I am Groot", avatar: UIImage(named: "Groot"), status: "Happy :)")


public final class CurrentUserService: UserService {
    
    private var currentUser: User?
    
    init(currentUser: User) {
        self.currentUser = currentUser
    }
    
    func authorizeUser(login: String) -> User? {
        if let currentUser = currentUser, currentUser.login == login {
            return currentUser
        } else {
            return nil
        }
    }
}







