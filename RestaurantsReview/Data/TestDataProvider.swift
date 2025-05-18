//
//  TestDataProvider.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import Foundation

class TestDataProvider {
    
    static let shared = TestDataProvider()
    
    private init() {}

    let testUser = User(
        name: "john_doe",
        email: "test@example.com",
        password: "Test1234",
        role: .admin
    )

    // MARK: - Generate 10 sample reviews
    private func generateSampleReviews() -> [Review] {
        var reviews: [Review] = []
        let now = Date()
        let oneDay: TimeInterval = 86400

        for i in 0..<10 {
            let review = Review(
                userId: testUser.id,
                comment: "Sample review \(i + 1)",
                rating: Int.random(in: 1...5),
                dateOfVisit: now.addingTimeInterval(-TimeInterval((i + 1) * Int(oneDay))),
                dateCreated: now.addingTimeInterval(-TimeInterval((i + 1) * Int(oneDay / 2)))
            )
            reviews.append(review)
        }

        return reviews
    }

    // MARK: - Generate 10 sample restaurants
    lazy var sampleRestaurants: [Restaurant] = {
        let reviews = generateSampleReviews()

        return (1...10).map { index in
            Restaurant(
                name: "Restaurant \(index)",
                cuisine: ["Italian", "Japanese", "American", "Mexican", "Thai", "Chinese", "French", "Greek", "Indian", "Spanish"][index % 10],
                imagePath: "image\(index)",
                reviews: Array(reviews.shuffled().prefix(Int.random(in: 0...5)))
            )
        }
    }()
}
