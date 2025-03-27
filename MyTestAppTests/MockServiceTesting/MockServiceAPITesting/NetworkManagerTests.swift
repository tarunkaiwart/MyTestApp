//
//  NetworkManagerTests.swift
//  MyTestAppTests
//
//  Created by Tarun Kaiwart on 26/03/25.
//

import XCTest
@testable import MyTestApp

final class NetworkManagerTests: XCTestCase {
    var mockAPIService: MockServiceAPI!
    var networkManager: NetworkManager!
    
    //Called before each test method is executed.
    //Used for setting up test data, initializing objects, and performing any necessary preparations.
    override func setUp() {
        super.setUp()
        mockAPIService = MockServiceAPI()
        networkManager = NetworkManager(apiService: mockAPIService)
    }
    //Called after each test method is executed.
    //Used for cleaning up resources, releasing objects, and resetting the environment.
    override func tearDown() {
        mockAPIService = nil
        networkManager = nil
        super.tearDown()
    }
    
    func testGetUsersSuccess() async throws {
        let mockJSONData = """
        [
        {
                        "id": 1,
                        "name": "Tarun Kumar",
                        "username": "tarunkumar211",
                        "email": "tarun@example.com",
                        "address": {
                            "street": "123 Main St",
                            "city": "Springfield",
                            "zipcode": "12345"
                        },
                        "phone": "123-456-7890",
                        "website": "example.com",
                        "company": {
                            "name": "Example Corp"
                        }
                    }
        ]
        """.data(using: .utf8)!
        
        mockAPIService.mockData = mockJSONData
        
        do {
            let users = try await networkManager.getUsers()
            XCTAssertEqual(users.count, 1)
            XCTAssertEqual(users.first?.name, "John Doe")
            XCTAssertEqual(users.first?.username, "johndoe")
            
        } catch {
            XCTFail("Unexpected Failure : \(error.localizedDescription)")
        }
    }
    
    func testGetUsers_Failure() async {
            //Simulate a network failure by injecting an APIError
            mockAPIService.mockError = APIError.networkError("Mocked network failure")

            do {
                _ = try await networkManager.getUsers()
                XCTFail("Expected network error but got success response")
            } catch let error as APIError {
                switch error {
                case .networkError(let message):
                    XCTAssertEqual(message, "Mocked network failure")
                    //Match exact error message
                default:
                    XCTFail("Expected network error but got different error: \(error)")
                }
            } catch {
                XCTFail("Unexpected error type received: \(error)")
            }
        }
}
