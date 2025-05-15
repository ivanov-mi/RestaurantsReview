//
//  ValidatorResult.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

struct ValidationResult {
    let isValid: Bool
    let error: ValidationError?

    static let success = ValidationResult(isValid: true, error: nil)

    static func failure(_ error: ValidationError) -> ValidationResult {
        return ValidationResult(isValid: false, error: error)
    }
}
