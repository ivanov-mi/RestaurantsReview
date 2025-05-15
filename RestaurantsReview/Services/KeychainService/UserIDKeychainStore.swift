//
//  UserIDKeychainStore.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import Foundation

class UserIDKeychainStore {
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
