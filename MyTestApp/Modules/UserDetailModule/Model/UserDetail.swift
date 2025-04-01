//
//  UserDetailModel.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 01/04/25.
//

import Foundation

struct UserDetail {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: String
    let phone: String
    let website: String
    let companyName: String

    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.address = UserDetail.formatAddress(user.address)
        self.phone = user.phone ?? "N/A"
        self.website = user.website ?? "N/A"
        self.companyName = user.company?.name ?? "N/A"
    }

    private static func formatAddress(_ address: User.Address?) -> String {
        guard let address = address else { return "N/A" }
        return [address.street, address.suite, address.city, address.zipcode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
