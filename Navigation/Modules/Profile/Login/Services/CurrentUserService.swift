//import Foundation
//
//public final class CurrentUserService: UserModelService {
//    
//    private var currentUser: UserModel
//    
//    init(currentUser: UserModel) {
//        self.currentUser = currentUser
//    }
//    
//    func authorizeUser(email: String) -> UserModel? {
//        
//        if let currentUser = CheckerService.shared.currentUser, currentUser.email == email {
//            return currentUser
//        }
//        return nil
//    }
//    
//}
