//
//  KeychainManager.swift
//  Fay
//
//  Created by Kyle Jennings on 7/12/24.
//

import Foundation

enum KeychainError: Error {
    case invalidData
    case saveFailure
    case itemNotFound
    case retrievalFailure
    case deleteFailure
}

class KeychainManager {

    enum KeychainIdentifier: String, CaseIterable {
        case authToken = "net.kylejennings.fay.keys.authToken"
    }

    static func updateKeychain(keyId: KeychainIdentifier,
                               stringData: String) throws {
        guard let data = stringData.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        try updateKeychain(keyId: keyId, data: data)
    }

    static private func updateKeychain(keyId: KeychainIdentifier, data: Data) throws {

        let updateQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keyId.rawValue]
        let updateAttributes: [String: Any] = [kSecValueData as String: data]
        let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)

        // If update didn't succeed attempt to add item
        if updateStatus != errSecSuccess {
            let addQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                           kSecAttrService as String: keyId.rawValue,
                                           kSecValueData as String: data]
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                throw KeychainError.saveFailure
            }
        }
    }

    static func getKeychainString(keyId: KeychainIdentifier) throws -> String {

        guard let keyValueData = try? getKeychainData(keyId: keyId) else {
            throw KeychainError.itemNotFound
        }

        guard let valueString = String(data: keyValueData,
                                       encoding: String.Encoding.utf8) else {
            throw KeychainError.invalidData
        }

        return valueString
    }

    static private func getKeychainData(keyId: KeychainIdentifier) throws -> Data {

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecAttrService as String: keyId.rawValue,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        guard status == errSecSuccess else {
            throw KeychainError.retrievalFailure
        }
        guard let existingItem = item as? [String: Any],
            let keyValueData = existingItem[kSecValueData as String] as? Data
            else {
                throw KeychainError.invalidData
        }

        return keyValueData
    }

    static private func deleteKeychainString(keyId: KeychainIdentifier) throws {

        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrService as String: keyId.rawValue]
        let deleteStatus = SecItemDelete(deleteQuery as CFDictionary)
        guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
            throw KeychainError.deleteFailure
        }
    }
}
