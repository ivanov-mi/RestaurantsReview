//
//  Review.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import Foundation

struct Review: Equatable, Hashable {
    let authorID: UUID
    let content: String
    let rating: Int
    let dateOfVisit: Date
}
