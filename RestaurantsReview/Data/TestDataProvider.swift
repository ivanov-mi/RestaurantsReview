//
//  TestDataProvider.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import Foundation

//final class TestDataProvider {
//    
//    static let shared = TestDataProvider()
//    
//    private init() { }
//    
//    // MARK: - Sample Users
//    let testUser = User(name: "Admin", email: "admin@example.com", password: "admin123")
//    
//    lazy var sampleReviews: [Review] = {
//        let now = Date()
//        let oneDay: TimeInterval = 86400
//
//        return [
//            Review(userId: testUser.id, comment: "Fantastic place!", rating: 5, dateOfVisit: now.addingTimeInterval(-oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Good food but slow service.", rating: 3, dateOfVisit: now.addingTimeInterval(-2 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Would not recommend.", rating: 1, dateOfVisit: now.addingTimeInterval(-3 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Great ambiance and service.", rating: 4, dateOfVisit: now.addingTimeInterval(-4 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Too noisy.", rating: 2, dateOfVisit: now.addingTimeInterval(-5 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Perfect date spot!", rating: 5, dateOfVisit: now.addingTimeInterval(-6 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Dessert was amazing.", rating: 4, dateOfVisit: now.addingTimeInterval(-7 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Waited an hour for food.", rating: 2, dateOfVisit: now.addingTimeInterval(-8 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Excellent value for money.", rating: 5, dateOfVisit: now.addingTimeInterval(-9 * oneDay), dateCreated: now),
//            Review(userId: testUser.id, comment: "Portions too small.", rating: 3, dateOfVisit: now.addingTimeInterval(-10 * oneDay), dateCreated: now)
//        ]
//    }()
//
//    let restaurants: [Restaurant] = [
//        Restaurant(name: "Sushi Place", cuisine: "Japanese", imagePath: "image1", reviews: [
//            Review(userId: UUID(), comment: "Fresh and delicious sushi!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Great ambiance, but rolls were average.", rating: 3, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "The best sashimi I've ever had!", rating: 5, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Pasta Corner", cuisine: "Italian", imagePath: "image2", reviews: [
//            Review(userId: UUID(), comment: "Authentic pasta, felt like Italy!", rating: 4, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Good food, but service was slow.", rating: 3, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Fantastic lasagna!", rating: 5, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "BBQ Haven", cuisine: "American", imagePath: "image3", reviews: [
//            Review(userId: UUID(), comment: "Best ribs ever!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "A bit too smoky for my taste.", rating: 3, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Amazing brisket!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Portions could be bigger.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Curry Delight", cuisine: "Indian", imagePath: "image4", reviews: [
//            Review(userId: UUID(), comment: "Spices hit perfectly!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Authentic flavors, loved the naan!", rating: 4, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Taco Fiesta", cuisine: "Mexican", imagePath: "image5", reviews: [
//            Review(userId: UUID(), comment: "Authentic street tacos.", rating: 4, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "The best carnitas in town!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//          Review(userId: UUID(), comment: "Salsa was a bit too spicy for me.", rating: 3, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Steakhouse Supreme", cuisine: "American", imagePath: "image6", reviews: [
//            Review(userId: UUID(), comment: "Perfectly cooked steak!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Good selection, but a bit pricey.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Dim Sum Delight", cuisine: "Chinese", imagePath: "image7", reviews: [
//            Review(userId: UUID(), comment: "Best dumplings in town!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Loved the variety of dim sum.", rating: 4, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Service was slow, but food was great!", rating: 3, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Greek Taverna", cuisine: "Greek", imagePath: "image8", reviews: [
//            Review(userId: UUID(), comment: "Amazing souvlaki and feta salad!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Authentic Greek flavors!", rating: 4, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Bakery Bliss", cuisine: "French", imagePath: "image9", reviews: [
//            Review(userId: UUID(), comment: "Best croissants I've ever had!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Great selection of pastries.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
//        ]),
//        Restaurant(name: "Japanese Ramen House", cuisine: "Japanese", imagePath: "image10", reviews: [
//            Review(userId: UUID(), comment: "Rich, flavorful broth!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
//            Review(userId: UUID(), comment: "Authentic ramen experience.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
//        ])
//    ]
//}


class TestDataProvider {
    
    static let shared = TestDataProvider()
    
    private init() {}

    let testUser = User(
        name: "john_doe",
        email: "test@example.com",
        password: "Test1234",
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
