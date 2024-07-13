//
//  NetworkError.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidUrl
    case badCredentials
}

extension NetworkError {
    /// User understandble error messages
    var displayText: String {
        switch self {
        case .invalidResponse:
            return "Invalid response was sent from server, please try again"

        case .invalidUrl:
            return "Invalid data set, please contact support for more help"

        case .badCredentials:
            return "Invalid credentials, please check your username and password, or sign in again"
        }
    }
}
