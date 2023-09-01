import UIKit

protocol UserService {
    func authorizeUser(login: String) throws -> User?
}

public class User {
    public var login: String
    public var fullName: String
    public var avatar: UIImage?
    public var status: String
    public var password: String
    
    init(login: String, fullName: String, avatar: UIImage?, status: String, password: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
        self.password = password
    }
    
}
    
private (set) var user = User(login: "Groot", fullName: "I am Groot", avatar: UIImage(named: "Groot"), status: "Happy :)", password: "Groot")

private (set) var testUser = User(login: "TestUser", fullName: "TestUser", avatar: UIImage(systemName: "person.fill.questionmark"), status: "Test is done", password: "TestUser")














