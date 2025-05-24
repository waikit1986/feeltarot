//
//  KeychainHelper.swift
//  feeltarot
//
//  Created by Low Wai Kit on 5/24/25.
//


import Foundation
import Security

class KeychainHelper {
    static let standard = KeychainHelper()

    func save(_ data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary) // Delete old item if exists
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Keychain save failed with status: \(status)")
        }
    }

    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecSuccess {
            return item as? Data
        }
        return nil
    }

    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}


// retrieve all user data

//if let savedUsernameData = KeychainHelper.standard.read(service: tokenService, account: usernameAccount),
//   let savedUsername = String(data: savedUsernameData, encoding: .utf8) {
//    print("Saved username: \(savedUsername)")
//}

