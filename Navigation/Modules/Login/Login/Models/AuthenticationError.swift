
import Foundation

enum AuthenticationError: Error, Equatable {
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
    
    static func == (lhs: AuthenticationError, rhs: AuthenticationError) -> Bool {
        switch (lhs, rhs) {
        case (.notAuthorized, .notAuthorized):
            return true
        case let (.custom(error1), .custom(error2)):
            return (error1 as NSError) == (error2 as NSError)
        default:
            return false
        }
    }
}
