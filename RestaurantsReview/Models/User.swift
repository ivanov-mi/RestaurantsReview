//
//  User.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import Foundation

struct User {
    var id: UUID
    var name: String
    var email: String
    var password: String
    var isAdmin: Bool
    
    init(name: String, email: String, password: String) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.password = password
        self.isAdmin = false
    }
    
    mutating func promoteToAdmin() {
        isAdmin = true
    }
    
    mutating func demoteToUser() {
        isAdmin = false
    }
    
    func authenticate(inputPassword: String) -> Bool {
        return inputPassword == password
    }
}
