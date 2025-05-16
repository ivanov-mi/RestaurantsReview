//
//  AuthInputValidatorResult.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

struct AuthInputValidatorResult {
    let isValid: Bool
    let error: AuthInputValidatorError?

    static let success = AuthInputValidatorResult(isValid: true, error: nil)

    static func failure(_ error: AuthInputValidatorError) -> AuthInputValidatorResult {
        return AuthInputValidatorResult(isValid: false, error: error)
    }
}
