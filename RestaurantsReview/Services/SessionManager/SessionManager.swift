//
//  SessionManager.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//


class SessionManager {
    static let shared = SessionManager()

    @UserDefaultOptional(key: .currentUser)
    private(set) static var user: User?

    private let keychain = UserIDKeychainStore()

    private init() {
        if let userId = keychain.loadUserId(),
           let user = SessionManager.user,
           user.id == userId {
            currentUser = user
        }
    }

    private(set) var currentUser: User?

    var isAuthenticated: Bool {
        currentUser != nil
    }

    var isAdmin: Bool {
        currentUser?.role == .admin
    }

    func login(user: User) {
        currentUser = user
        keychain.saveUserId(user.id)
        SessionManager.user = user
    }

    func logout() {
        currentUser = nil
        keychain.clearUserId()
        SessionManager.user = nil
    }
}
