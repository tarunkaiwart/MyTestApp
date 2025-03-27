//
//  DataParsingTests.swift
//  MyTestAppTests
//
//  Created by Tarun Kaiwart on 26/03/25.

import XCTest
@testable import MyTestApp

class DataParsingTests: XCTestCase {
    
    func testUserModelParsing() throws {
        let jsonData = """
        {
            "id": 2,
            "name": "Jane Doe",
            "username": "janedoe",
            "email": "jane@example.com"
        
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let user = try decoder.decode(User.self, from: jsonData)
            XCTAssertEqual(user.id, 2)
            XCTAssertEqual(user.name, "Jane Doe")
        } catch {
            XCTFail("Failed to decode User model: \(error.localizedDescription)")
        }
    }
}
