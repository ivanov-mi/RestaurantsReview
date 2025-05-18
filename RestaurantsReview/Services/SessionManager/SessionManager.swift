//
//  SessionManager.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//


class SessionManager {

    // MARK: - Properties
    static let shared = SessionManager()
    private(set) var currentUser: User?
    
    private let keychain = UserIDKeychainStore()
    
    var isAuthenticated: Bool {
        keychain.loadUserId() != nil && currentUser != nil
    }

    var isAdmin: Bool {
        currentUser?.role == .admin
    }

    // MARK: - Public methods
    func login(user: User) {
        keychain.saveUserId(user.id)
        currentUser = user
    }

    func logout() {
        keychain.clearUserId()
        currentUser = nil
    }
    
    // MARK: - Init
    private init() {
        if let userId = keychain.loadUserId(),
           let user = PersistenceManager.shared.users.fetch(by: userId) {
            currentUser = user
        } else {
            currentUser = nil
        }
    }
}
