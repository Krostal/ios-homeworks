
import FirebaseAuth

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
        currentUser != nil
    }
    
    static let shared = CheckerService()
    
    private init() {}
    
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
