//
//  NetworkClient.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

class NetworkClient {

    static func getDecodableObject<T: Decodable>(path: String) async throws -> T {
        let request = try getRequest(path: path)
        print("Making request to \(request.url?.absoluteString ?? "ERROR")")
        let (data, response) = try await URLSession.shared.data(for: request)

        try checkResponse(response: response)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }

    static func post<T: Encodable, 
                        R: Decodable>(path: String,
                                      value: T) async throws -> R? {

        let encoder = JSONEncoder()
        let valueData = try encoder.encode(value)
        var request = try getRequest(path: path)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = valueData
        print("Making request to \(request.url?.absoluteString ?? "ERROR")")
        let (data, response) = try await URLSession.shared.data(for: request)

        try checkResponse(response: response)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(R.self, from: data)
    }

    private static func getRequest(path: String) throws -> URLRequest {
        guard let baseUrl = URL(string: NetworkConstants.baseUrl) else {
            throw NetworkError.invalidUrl
        }
        let authToken = try? KeychainManager.getKeychainString(keyId: .authToken)
        let requestUrl = baseUrl
            .appending(path: path)

        var request = URLRequest(url: requestUrl)
        if let authToken {
            request.setValue("Bearer \(authToken)",
                             forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        return request
    }

    private static func checkResponse(response: URLResponse) throws {
        guard let urlResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if urlResponse.statusCode == 401 {
            throw NetworkError.badCredentials
        } else if !(200...299 ~= urlResponse.statusCode) {
            throw NetworkError.invalidResponse
        }
    }
}
