//
//  APIError.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

/// Enum representing possible errors that can occur during API requests.
enum APIError: Error {
    
    /// Indicates that the response from the server is invalid.
    case invalidResponse
    
    /// Indicates a failure in decoding the received data.
    case decodingError
    
    /// Represents a network-related error with an associated error message.
    case networkError(String)
}
