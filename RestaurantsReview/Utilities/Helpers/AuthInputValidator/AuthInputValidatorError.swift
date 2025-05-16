//
//  AuthInputValidatorError.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import Foundation

enum AuthInputValidatorError: LocalizedError, Equatable {
    case invalidUsername
    case invalidEmail
    case passwordTooShort(minLength: Int)
    case passwordMissingDigit
    case passwordMissingLetter

    var errorDescription: String? {
        switch self {
        case .invalidUsername:
            return "Username can contain only letters, numbers, dots, or underscores"
        case .invalidEmail:
            return "Invalid Email"
        case .passwordTooShort(let minLength):
            return "Password must be at least \(minLength) characters"
        case .passwordMissingDigit:
            return "Password must contain at least one digit"
        case .passwordMissingLetter:
            return "Password must contain at least one letter"
        }
    }
}
