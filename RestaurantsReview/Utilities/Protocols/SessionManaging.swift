//
//  SessionManaging.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

protocol SessionManaging {
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }
    var isAdmin: Bool { get }
    
    func login(user: User)
    func logout()
    func updateCurrentUser()
}

extension SessionManager: SessionManaging {}
