//
//  AuthService.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

private struct LoginResponse: Decodable {
    let token: String
}

protocol AuthService: AnyObject {
    func loginUser(user: LoginUserPost) async throws
}

class AuthProvider: AuthService {

    func loginUser(user: LoginUserPost) async throws {
        let response: LoginResponse? = try await NetworkClient.post(
            path: NetworkConstants.signinPath,
            value: user)

        guard let token = response?.token else {
            throw NetworkError.invalidResponse
        }
        // Once we have the token we set it in the keychain
        try KeychainManager.updateKeychain(keyId: .authToken, stringData: token)
        print("Successful Login")
    }
}

class MockAuthProvider: AuthService {
    func loginUser(user: LoginUserPost) async throws {
        
    }
}
