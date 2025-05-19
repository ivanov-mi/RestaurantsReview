//
//  SessionManaging.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

protocol SessionManaging {
    var currentUser: User? { get }
}

extension SessionManager: SessionManaging {}
