//
//  MockStore.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

class MockStore: PersistenceStoring {
    private var users: [UUID: User] = [:]
    private var reviews: [UUID: Review] = [:]
    private var restaurants: [UUID: Restaurant] = [:]
    
    init(testDataRequired: Bool = false) {
        if testDataRequired {
            provideTestData()
        }
    }

    private func provideTestData() {
        let provider = TestDataProvider.shared
        create(provider.testUser)
        provider.restaurantsWithReviews.forEach { create($0) }
        provider.sampleReviews.forEach { create($0) }
    }

    // MARK: - Users
    func create(_ user: User) { users[user.id] = user }
    func fetch(by id: UUID) -> User? { users[id] }
    func update(_ user: User) { users[user.id] = user }
    func delete(_ user: User) { users.removeValue(forKey: user.id) }

    func users(forRestaurant id: UUID) -> [User] {
        let userIds = reviews.values.filter { $0.restaurantId == id }.map { $0.userId }
        return userIds.compactMap { users[$0] }
    }

    // MARK: - Reviews
    func create(_ review: Review) { reviews[review.id] = review }
    func fetch(by id: UUID) -> Review? { reviews[id] }
    func update(_ review: Review) { reviews[review.id] = review }
    func delete(_ review: Review) { reviews.removeValue(forKey: review.id) }

    func reviews(forUser id: UUID) -> [Review] {
        reviews.values.filter { $0.userId == id }
    }

    func reviews(forRestaurant id: UUID) -> [Review] {
        reviews.values.filter { $0.restaurantId == id }
    }

    // MARK: - Restaurants
    func create(_ restaurant: Restaurant) { restaurants[restaurant.id] = restaurant }
    func fetch(by id: UUID) -> Restaurant? { restaurants[id] }
    func update(_ restaurant: Restaurant) { restaurants[restaurant.id] = restaurant }
    func delete(_ restaurant: Restaurant) { restaurants.removeValue(forKey: restaurant.id) }
}
