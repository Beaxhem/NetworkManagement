import XCTest
@testable import NetworkManagement

final class NetworkManagementTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NetworkManagement().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
