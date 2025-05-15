//
//  UserDefaultOptional.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import Foundation

@propertyWrapper
struct UserDefaultOptional<T: Codable> {
    private let key: UserDefaultsKey
    private let userDefaults: UserDefaults

    init(key: UserDefaultsKey, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }

    var wrappedValue: T? {
        get {
            guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            if let value = newValue,
               let data = try? JSONEncoder().encode(value) {
                userDefaults.set(data, forKey: key.rawValue)
            } else {
                userDefaults.removeObject(forKey: key.rawValue)
            }
        }
    }
}


