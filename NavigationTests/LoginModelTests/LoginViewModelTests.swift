

@testable import Navigation
import XCTest
import FirebaseAuth

enum AuthError: Error {
    case someError
}

class LoginInspectorTests: XCTestCase {

    func testSuccessfulAuthentication() {

        let loginInspector = LoginInspectorMock(signInMethods: ["email"])
        
        var result: Result<UserModel, AuthenticationError>?
        let expectation = XCTestExpectation(description: "Should authenticate successfully")
        
        loginInspector.checkCredentials(email: "groot@gmail.com", password: "groot8") { completionResult in
            result = completionResult
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(try? result?.get(), "Authentication should be successful")
    }

    func testNotAuthorized() {

        let loginInspector = LoginInspectorMock(signInMethods: [])

        var result: Result<UserModel, AuthenticationError>?
        let expectation = XCTestExpectation(description: "Should not be authorized")

        loginInspector.checkCredentials(email: "test@example.com", password: "password") { completionResult in
            result = completionResult
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try result?.get(), "Should throw notAuthorized error") { error in
            XCTAssertTrue(error is AuthenticationError)
            XCTAssertEqual(error as? AuthenticationError, AuthenticationError.notAuthorized)
        }
    }

    func testAuthenticationError() {

        let loginInspector = LoginInspectorMock(error: AuthError.someError)

        var result: Result<UserModel, AuthenticationError>?
        let expectation = XCTestExpectation(description: "Should result in an authentication error")

        loginInspector.checkCredentials(email: "test@example.com", password: "password") { completionResult in
            result = completionResult
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertThrowsError(try result?.get(), "Should throw custom authentication error") { error in
            XCTAssertTrue(error is AuthenticationError)
            XCTAssertEqual(error as? AuthenticationError, AuthenticationError.custom(AuthError.someError))
        }
    }
}
