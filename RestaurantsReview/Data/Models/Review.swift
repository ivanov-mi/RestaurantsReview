//
//  Review.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

struct Review: Hashable {
    let id: UUID
    var rating: Int
    var comment: String
    var dateOfVisit: Date
    var dateCreated: Date
    var userId: UUID
    var restaurantId: UUID
}
