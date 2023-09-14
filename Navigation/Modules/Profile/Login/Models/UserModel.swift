import FirebaseAuth
import UIKit


protocol UserModelService {
    func authorizeUser(email: String) -> UserModel?
}

final class UserModel {
    
    let email: String
    let name: String
    let avatar: UIImage?
    let status: String
    let password: String
    
    init(from firUser: User) {
        self.email = firUser.email ?? ""
        
#if DEBUG
        self.name = firUser.displayName ?? "TestUser"
        self.avatar = UIImage(systemName: "person.fill.questionmark")
        self.status = "Test is done"
        self.password = "TestUser"
#else
        self.name = firUser.displayName ?? "I am Groot"
        self.avatar = UIImage(named: "Groot")
        self.status = "Happy :)"
        self.password = "groot8"
#endif
        
    }
}
