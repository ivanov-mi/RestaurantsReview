//
//  Restaurant.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import Foundation

struct Restaurant {
    let name: String
    let cuisine: String
    let imagePath: String?
    var reviews: [Review]
    
    var rating: Double? {
        guard !reviews.isEmpty else {
            return nil
        }
        
        let average = reviews.map { Double($0.rating) }.reduce(0, +) / Double(reviews.count)
        return average
    }
    
    var highestRated: Review? {
        reviews.max(by: { $0.rating < $1.rating })
    }

    var lowestRated: Review? {
        reviews.min(by: { $0.rating < $1.rating })
    }

    var latestReview: Review? {
        reviews.sorted(by: { $0.dateCreated > $1.dateCreated }).first
    }
}
