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
    private let persistenceManager: PersistenceManaging
    
    var isAuthenticated: Bool {
        keychain.loadUserId() != nil && currentUser != nil
    }

    var isAdmin: Bool {
        currentUser?.isAdmin ?? false
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
    private init(persistenceManager: PersistenceManaging = CoreDataManager.shared) {
        self.persistenceManager = persistenceManager
        
        if let userId = keychain.loadUserId() {
            currentUser = persistenceManager.fetchUser(by: userId)
        }
    }
}
