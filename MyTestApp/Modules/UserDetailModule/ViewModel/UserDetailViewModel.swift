//
//  UserDetailViewModel.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 01/04/25.
//

import Foundation

class UserDetailViewModel {
    
    private let userDetail: UserDetail

    init(userDetail: UserDetail) {
        self.userDetail = userDetail
    }

    var fullName: String { userDetail.name }
    var username: String { "@\(userDetail.username)" }
    var email: String { userDetail.email }
    var address: String { userDetail.address }
    var phone: String { userDetail.phone  }

    private func formattedAddress(from address: User.Address?) -> String {
        guard let address = address else { return "N/A" }
        return [address.street, address.suite, address.city, address.zipcode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}

