//
//  APIError.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case decodingError
    case networkError(String)
}
