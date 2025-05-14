//
//  User.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import Foundation

enum Role: String, Codable {
    case user, admin
}

struct User {
    let id: UUID
    var username: String
    var email: String
    var password: String
    var role: Role
    
    init(name: String, email: String, password: String) {
        self.id = UUID()
        self.username = name
        self.email = email
        self.password = password
        self.role = .user
    }
    
    func authenticate(inputPassword: String) -> Bool {
        return inputPassword == password
    }
}
