import XCTest
@testable import NetworkManagement

extension Endpoints {
    
    static let google = Endpoint<Data>(host: "https://google.com", path: "", parameters: nil)

    static let notFoundGoogle = Endpoint<Data>(host: "https://google.com", path: "/notFound", parameters: nil)

    static let badURL = Endpoint<Data>(host: "google", path: "")

    static let tasks = Endpoint<Task>(host: "https://jsonplaceholder.typicode.com", path: "/todos/1")
}

final class NetworkManagementTests: XCTestCase {

    let networkManager = NetworkManager()

    func testRequestSuccess() {
        let expectation = XCTestExpectation()

        networkManager.dataTask(endpoint: Endpoints.google) { res in
            switch res {
                case .success(let data):
                    print(data)
                    expectation.fulfill()
                case.failure(let error):
                    print(error)
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testNotFound() {
        let expectation = XCTestExpectation()

        networkManager.dataTask(endpoint: Endpoints.notFoundGoogle) { res in
            switch res {
                case .success(let data):
                    print(data)
                case .failure(let networkError):
                    XCTAssertEqual(networkError, NetworkError.notFound)
                    expectation.fulfill()
            }
        }


        wait(for: [expectation], timeout: 10)
    }

    func testBadLink() {
        let expectation = XCTestExpectation()

        networkManager.dataTask(endpoint: Endpoints.badURL) { res in
            switch res {
                case .failure(let error):
                    XCTAssertEqual(error, NetworkError.badEndpoint)
                    expectation.fulfill()
                case .success(_):
                    break
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testDataParsing() {
        let expectation = XCTestExpectation()

        networkManager.dataTask(endpoint: Endpoints.tasks) { res in
            switch res {
                case .success(let task):
                    XCTAssertEqual(Task(id: 1, userId: 1, title: "delectus aut autem", completed: false), task)
                    expectation.fulfill()
                case .failure(_):
                    break
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    static var allTests = [
        ("testRequestSuccess", testRequestSuccess),
        ("testNotFound", testNotFound),
        ("testBadLink", testBadLink),

    ]
}
