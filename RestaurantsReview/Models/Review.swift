//
//  Review.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import Foundation

struct Review: Equatable, Hashable {
    let userId: UUID
    let comment: String
    let rating: Int
    let dateOfVisit: Date
    let dateCreated: Date
}
