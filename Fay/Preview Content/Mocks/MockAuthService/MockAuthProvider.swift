//
//  MockAuthProvider.swift
//  Fay
//
//  Created by Kyle Jennings on 7/19/24.
//

import Foundation

class MockAuthProvider: AuthService {
    func loginUser(user: LoginUserPost) async throws {
        throw NetworkError.badCredentials
    }
}
