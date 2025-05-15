//
//  Validator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import Foundation

struct Validator {

    static func validateUsername(_ username: String) -> ValidationResult {
        let isValid = NSPredicate(format: "SELF MATCHES %@", Configuration.Regex.username).evaluate(with: username)

        return isValid ? .success : .failure(.invalidUsername)
    }

    static func validateEmail(_ email: String) -> ValidationResult {
        let isValid = NSPredicate(format: "SELF MATCHES %@", Configuration.Regex.email).evaluate(with: email)

        return isValid ? .success : .failure(.invalidEmail)
    }

    static func validatePasswordCreation(_ password: String) -> ValidationResult {
        if password.count < Configuration.Rules.passwordMinLength {
            return .failure(.passwordTooShort(minLength: Configuration.Rules.passwordMinLength))
        }
        if !password.contains(where: \.isNumber) {
            return .failure(.passwordMissingDigit)
        }
        if !password.contains(where: \.isLetter) {
            return .failure(.passwordMissingLetter)
        }
        return .success
    }
    
    static func validateLoginPassword(_ password: String) -> ValidationResult {
        if password.count < Configuration.Rules.passwordMinLength {
            return .failure(.passwordTooShort(minLength: Configuration.Rules.passwordMinLength))
        }
        return .success
    }
}

extension Validator {
    enum Configuration {
        enum Regex {
            static let username = "^[A-Za-z0-9._]+$"
            static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        }

        enum Rules {
            static let passwordMinLength = 8
        }
    }
}
