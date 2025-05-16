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
    
    @UserDefaultOptional(key: .currentUser)
    private(set) static var user: User?
    
    private let keychain = UserIDKeychainStore()
    
    var isAuthenticated: Bool {
        keychain.loadUserId() != nil
    }

    var isAdmin: Bool {
        currentUser?.role == .admin
    }

    // MARK: - Public methods
    func login(user: User) {
        keychain.saveUserId(user.id)
        currentUser = user
        SessionManager.user = user
    }

    func logout() {
        keychain.clearUserId()
        currentUser = nil
        SessionManager.user = nil
    }
    
    // MARK: - Init
    private init() {
        if let userId = keychain.loadUserId(),
           let storedUser = SessionManager.user,
           storedUser.id == userId {
            currentUser = storedUser
        } else {
            currentUser = nil
        }
    }
}
