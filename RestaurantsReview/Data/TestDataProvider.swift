//
//  TestDataProvider.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import Foundation

final class TestDataProvider {
    
    static let shared = TestDataProvider()
    
    private init() {}

    let testUser = User(
        name: "john_doe",
        email: "test@example.com",
        password: "Test1234",
        role: .admin
    )

    // Generate 10 sample restaurants
    lazy var sampleRestaurants: [Restaurant] = {
        (1...10).map { index in
            Restaurant(
                name: "Restaurant \(index)",
                cuisine: ["Italian", "Japanese", "American", "Mexican", "Thai", "Chinese", "French", "Greek", "Indian", "Spanish"][index % 10],
                imagePath: "image\(index)"
            )
        }
    }()

    // Generate 30 reviews across restaurants and user
    lazy var sampleReviews: [Review] = {
        var allReviews: [Review] = []
        let now = Date()
        let oneDay: TimeInterval = 86400

        for i in 0..<30 {
            let restaurant = sampleRestaurants.randomElement()!
            let review = Review(
                userId: testUser.id,
                restaurantId: restaurant.id,
                comment: "Sample review \(i + 1)",
                rating: Int.random(in: 1...5),
                dateOfVisit: now.addingTimeInterval(-TimeInterval((i + 1) * Int(oneDay))),
                dateCreated: now.addingTimeInterval(-TimeInterval((i + 1) * Int(oneDay / 2)))
            )
            allReviews.append(review)
        }

        return allReviews
    }()

    // Restaurants with embedded reviews
    lazy var restaurantsWithReviews: [Restaurant] = {
        sampleRestaurants.map { restaurant in
            let reviews = sampleReviews.filter { $0.restaurantId == restaurant.id }
            var updatedRestaurant = restaurant
            updatedRestaurant.reviews = reviews
            return updatedRestaurant
        }
    }()
}

