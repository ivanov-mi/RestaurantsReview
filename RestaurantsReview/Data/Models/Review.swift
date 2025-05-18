//
//  Review.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import Foundation

struct Review: Equatable, Hashable {
    let id: UUID
    let userId: UUID
    let restaurantId: UUID
    let comment: String
    let rating: Int
    let dateOfVisit: Date
    let dateCreated: Date

    init(userId: UUID, restaurantId: UUID, comment: String, rating: Int, dateOfVisit: Date, dateCreated: Date = Date()) {
        self.id = UUID()
        self.userId = userId
        self.restaurantId = restaurantId
        self.comment = comment
        self.rating = rating
        self.dateOfVisit = dateOfVisit
        self.dateCreated = dateCreated
    }
}
