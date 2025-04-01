//
//  User.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

struct User: Codable {

    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?

    struct Address: Codable {
        let street: String?
        let suite: String?
        let city: String?
        let zipcode: String?
        let geo: Geo?
    }

    struct Geo: Codable {
        let lat: String?
        let lng: String?
    }

    struct Company: Codable {
        let name: String?
    }

    // Mock initializer for testing
    init(id: Int = 1, name: String = "Test User", username: String = "testuser", email: String = "test@example.com", address: Address? = nil, phone: String? = nil, website: String? = nil, company: Company? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address ?? Address(street: "123 Main St", suite: "Apt 4", city: "New York", zipcode: "10001", geo: Geo(lat: "40.7128", lng: "-74.0060"))
        self.phone = phone
        self.website = website
        self.company = company ?? Company(name: "Tech Corp")
    }
}

