//
//  UserDetailViewModel.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 01/04/25.
//

import Foundation
/// ViewModel responsible for preparing user details for presentation in the UserDetailViewController.
class UserDetailViewModel {
    
    /// Private property to hold user details, ensuring encapsulation.
    private let userDetail: UserDetail

    /// Initializes the ViewModel with a `UserDetail` instance.
    /// - Parameter userDetail: The user detail model containing raw data.
    init(userDetail: UserDetail) {
        self.userDetail = userDetail
    }

    /// Computed property to return the user's full name.
    var fullName: String { userDetail.name }

    /// Computed property to return the formatted username with "@" prefix.
    var username: String { "@\(userDetail.username)" }

    /// Computed property to return the user's email address.
    var email: String { userDetail.email }

    /// Computed property to return the formatted user address.
    var address: String { formattedAddress(from: userDetail.address) }

    /// Computed property to return the user's phone number, defaulting to "N/A" if nil.
    var phone: String { userDetail.phone }

    /// Formats the address from the `User.Address` model into a readable string.
    /// - Parameter address: The optional `User.Address` model.
    /// - Returns: A formatted address string or "N/A" if the address is missing.
    private func formattedAddress(from address: User.Address?) -> String {
        guard let address = address else { return "N/A" }
        return [address.street, address.suite, address.city, address.zipcode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}

