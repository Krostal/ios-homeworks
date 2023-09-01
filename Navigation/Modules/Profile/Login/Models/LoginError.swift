
import Foundation

enum LoginError: Error {
    case emptyUserName
    case emptyPassword
    case invalidUserName
    case invalidPassword
    case unauthorized
}
