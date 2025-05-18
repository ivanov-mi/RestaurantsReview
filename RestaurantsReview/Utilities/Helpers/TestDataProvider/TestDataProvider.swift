//
//  TestDataProvider.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import Foundation

class TestDataProvider {

    // MARK: - Populate Test Data
    static func populateTestData(using manager: CoreDataManager) {
        // Prevent duplication
        if !manager.fetchAllUsers().isEmpty { return }

        // Register test users
        let admin = register(testUser: .admin, using: manager)
        let regular = register(testUser: .regular, using: manager)

        // Create 10 restaurants
        let restaurants: [Restaurant] = (0..<TestData.restaurantNames.count).compactMap { index in
            let name = TestData.restaurantNames[index]
            let cuisine = TestData.cuisines.randomElement()!
            let imagePath = "image\(index + 1)"
            return manager.createRestaurant(name: name, cuisine: cuisine, imagePath: imagePath)
        }

        // Add 0–5 reviews per restaurant
        for restaurant in restaurants {
            let numberOfReviews = Int.random(in: 0...5)

            for _ in 0..<numberOfReviews {
                guard let user = Bool.random() ? admin : regular else { continue }

                let comment = TestData.reviewComments.randomElement()!
                let rating = Int.random(in: 1...5)
                let daysAgo = Double.random(in: 1...90)
                let dateOfVisit = Date(timeIntervalSinceNow: -daysAgo * 86400)

                let review = manager.addReview(
                    restaurantId: restaurant.id,
                    userId: user.id,
                    comment: comment,
                    rating: rating,
                    dateOfVisit: dateOfVisit
                )

                if review == nil {
                    print("Failed to create review for restaurant \(restaurant.name)")
                }
            }
        }
    }

    // MARK: - Clear Test Data
    static func clearData(using manager: CoreDataManager) {
        manager.deleteAllReviews()
        manager.deleteAllRestaurants()
        manager.deleteAllUsers()
    }

    // MARK: - Register a Test User
    private static func register(testUser: TestData.User, using manager: CoreDataManager) -> User? {
        return manager.registerUser(
            username: testUser.username,
            email: testUser.email,
            password: testUser.password,
            isAdmin: testUser.isAdmin
        )
    }

    // MARK: - Check if Test Data Exists
    static func isTestingDataAvailable(using manager: CoreDataManager) -> Bool {
        return !manager.fetchAllUsers().isEmpty ||
               !manager.fetchAllRestaurants().isEmpty ||
               !manager.fetchAllReviews().isEmpty
    }
}
