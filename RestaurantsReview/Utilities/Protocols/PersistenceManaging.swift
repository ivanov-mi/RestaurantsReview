//
//  PersistenceManager.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

protocol PersistenceManaging {

    // MARK: - Users
    func registerUser(username: String, email: String, password: String, isAdmin: Bool) -> User?
    func login(email: String, password: String) -> User?
    func fetchAllUsers() -> [User]
    func fetchUser(by id: UUID) -> User?
    func changeAdminStatus(for userId: UUID, to isAdmin: Bool) -> User?
    func deleteAllUsers()
    func deleteUser(userId: UUID)

    // MARK: - Restaurants
    func fetchAllRestaurants() -> [Restaurant]
    func createRestaurant(name: String, cuisine: String, imagePath: String?) -> Restaurant?
    func deleteAllRestaurants()
    func deleteRestaurant(restaurantId: UUID)
    func averageRating(for restaurantId: UUID) -> Double?
    func reviewCount(for restaurantId: UUID) -> Int

    // MARK: - Reviews
    func addReview(restaurantId: UUID, userId: UUID, comment: String, rating: Int, dateOfVisit: Date) -> Review?
    func fetchReviews(for restaurantId: UUID) -> [Review]
    func fetchReview(by id: UUID) -> Review?
    func fetchAllReviews() -> [Review]
    func deleteAllReviews()
    func deleteReview(reviewId: UUID)
}
