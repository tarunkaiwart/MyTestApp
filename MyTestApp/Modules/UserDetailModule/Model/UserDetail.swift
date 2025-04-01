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
    let address: User.Address?
    let phone: String
    let website: String
    let company: String

    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.address = user.address
        self.phone = user.phone ?? "N/A"
        self.website = user.website ?? "N/A"
        self.company = user.company?.name ?? "N/A"
    }
}
