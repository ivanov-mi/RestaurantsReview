//
//  TestData.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

import Foundation

enum TestData {
    
    // MARK: - Test Strings
    static let reviewComments = [
        "Great",
        "Okay",
        "Meh",
        "Amazing",
        "Would not return"
    ]

    static let cuisines = [
        "Italian",
        "Mexican",
        "Japanese",
        "Bulgarian",
        "Indian"
    ]

    static let restaurantNames = [
        "Bella Napoli",
        "El Sombrero",
        "Sakura Sushi",
        "Mehana Vodenitsata",
        "Curry Kingdom",
        "Trattoria Roma",
        "Taco Loco",
        "Tokyo Dine",
        "Bulgarian Bites",
        "Spice Route"
    ]

    // MARK: - Test User Enum
    enum User {
        case admin
        case regular

        var username: String {
            switch self {
            case .admin: return "admin"
            case .regular: return "user"
            }
        }

        var email: String {
            switch self {
            case .admin: return "admin@example.com"
            case .regular: return "user@example.com"
            }
        }

        var password: String {
            switch self {
            case .admin: return "Admin123"
            case .regular: return "User123"
            }
        }

        var isAdmin: Bool {
            switch self {
            case .admin: return true
            case .regular: return false
            }
        }
    }
}

