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
    var reviews: [Review]
    
    var rating: Double? {
        guard !reviews.isEmpty else {
            return nil
        }
        
        let average = reviews.map { Double($0.rating) }.reduce(0, +) / Double(reviews.count)
        return average
    }
}
