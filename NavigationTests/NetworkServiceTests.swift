

@testable import Navigation
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift

class NetworkServiceTests: XCTestCase {

    func testRequestSuccess() {

        let configuration = AppConfiguration.people
        
        stub(condition: isHost(configuration.url?.host ?? "")) { _ in
            let data = "Success".data(using: .utf8)!
            return HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }
        
        let expectation = XCTestExpectation(description: "Request should succeed")

        NetworkService.request(for: configuration)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

        HTTPStubs.removeAllStubs()
    }

    func testRequestFailure() {
        let configuration = AppConfiguration.starships

        stub(condition: isHost(configuration.url?.host ?? "")) { _ in
            let data = "Not Found".data(using: .utf8)!
            return HTTPStubsResponse(data: data, statusCode: 404, headers: nil)
        }

        let expectation = XCTestExpectation(description: "Request should fail")

        NetworkService.request(for: configuration)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)

        HTTPStubs.removeAllStubs()
    }
}
