//
//  User.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

struct User: Hashable {
    let id: UUID
    var email: String
    var username: String
    var isAdmin: Bool
}
