//
//  KeychainManager.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    func save(_ data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecValueData as String   : data
        ]

        // Delete old item if it exists
        SecItemDelete(query as CFDictionary)

        // Add new item
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else { return nil }
        return result as? Data
    }

    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrService as String : service,
            kSecAttrAccount as String : account
        ]

        SecItemDelete(query as CFDictionary)
    }
}

class SecureStorage {
    private let service = Bundle.main.bundleIdentifier ??  "demo.ivanov-mi.RestaurantsReview"
    private let account = "userId"

    func saveUserId(_ id: UUID) {
        let idString = id.uuidString
        guard let data = idString.data(using: .utf8) else { return }
        KeychainManager.shared.save(data, service: service, account: account)
    }

    func loadUserId() -> UUID? {
        guard let data = KeychainManager.shared.read(service: service, account: account),
              let idString = String(data: data, encoding: .utf8) else { return nil }

        return UUID(uuidString: idString)
    }

    func clearUserId() {
        KeychainManager.shared.delete(service: service, account: account)
    }
}
