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
        currentUser != nil
    }

    var isAdmin: Bool {
        currentUser?.role == .admin
    }

    // MARK: - Public methods
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
    
    // MARK: - Init
    private init() {
        if let userId = keychain.loadUserId(),
           let user = SessionManager.user,
           user.id == userId {
            currentUser = user
        }
    }
}
