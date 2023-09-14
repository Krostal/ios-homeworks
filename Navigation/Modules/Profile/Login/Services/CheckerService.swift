
import FirebaseAuth
import Foundation

protocol CheckerServiceProtocol {
    
    var isLogIn: Bool { get }
    var currentUser: UserModel? { get }
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, AuthenticationError>) -> Void
    )
    
    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, AuthenticationError>) -> Void
    )
    
    func signOut(completion: @escaping (Result<Void, AuthenticationError>) -> Void)
}

final class CheckerService: CheckerServiceProtocol {
    
    private lazy var firebaseAuth = Auth.auth()

    var currentUser: UserModel? {
        if let currentUser = firebaseAuth.currentUser {
            return UserModel(from: currentUser)
        }
        return nil
    }
    
    var isLogIn: Bool {
        if let currentUser = firebaseAuth.currentUser {
                // Проверить наличие пользователя в Firebase
                currentUser.getIDTokenForcingRefresh(true) { (token, error) in
                    if let error = error {
                        print("Ошибка проверки статуса входа: \(error)")
                    } else {
                        // Пользователь есть в Firebase
                        print("Пользователь \(currentUser.email) вошел в Firebase")
                    }
                }
                return true
            }
            
            return false
    }
    
    static let shared = CheckerService()
    
    private init() {
//        if let firUser = firebaseAuth.currentUser {
//            currentUser = UserModel(from: firUser)
//        }
    }
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, AuthenticationError>) -> Void
    ) {
        firebaseAuth.createUser(withEmail: email, password: password) { authData, error in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            guard let firUser = authData?.user else {
                completion(.failure(.registrationError))
                return
            }
            
            let user = UserModel(from: firUser)
//            self.currentUser = user
            completion(.success(user))
        }
        
    }
    
    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, AuthenticationError>) -> Void
    ) {
        firebaseAuth.signIn(withEmail: email, password: password) { authData, error in
            if let error {
                completion(.failure(.custom(error)))
                return
            }
            
            guard let firUser = authData?.user else {
                completion(.failure(.notAuthorized))
                return
            }
            
            let user = UserModel(from: firUser)
//            self.currentUser = user
            completion(.success(user))
        }
    }
    
    func signOut(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        do {
            try firebaseAuth.signOut()
            completion(.success(()))
        } catch {
            completion(.failure(.custom(error)))
        }
    }
    
    
}
