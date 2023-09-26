
import Foundation

enum AuthenticationError: Error {
    case custom(Error)
    case registrationError
    case notAuthorized
    
    var errorDescription: String {
        switch self {
        case .custom(let error):
            return error.localizedDescription
        case .registrationError:
            return "Registration Error"
        case .notAuthorized:
            return "User is not authorized"
        }
    }
}
