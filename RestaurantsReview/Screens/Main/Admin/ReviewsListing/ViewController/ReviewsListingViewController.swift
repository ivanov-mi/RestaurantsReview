//
//  ReviewsListingViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

import UIKit

// MARK: - ReviewsListingViewControllerCoordinator
protocol ReviewsListingViewControllerCoordinator: AnyObject {
    func didSelectReview(_ review: Review, from controller: ReviewsListingViewController)
}

// MARK: - ReviewsListingViewController
class ReviewsListingViewController: UITableViewController {

    // MARK: - Properties
    weak var coordinator: ReviewsListingViewControllerCoordinator?
    var persistenceManager: PersistenceManaging!
    private var reviews: [Review] = []
    private var restaurants: [Restaurant] = []
    private var users: [User] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"

        tableView.register(ReviewsListingTableViewCell.nib, forCellReuseIdentifier: ReviewsListingTableViewCell.identifier)
        loadReviews()
    }

    // MARK: - Data
    private func loadReviews() {
        reviews = persistenceManager.fetchAllReviews()
        restaurants = persistenceManager.fetchAllRestaurants()
        users = persistenceManager.fetchAllUsers()
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsListingTableViewCell.identifier, for: indexPath) as! ReviewsListingTableViewCell

        let review = reviews[indexPath.row]
        let restaurantName = restaurants.first(where: { $0.id == review.restaurantId })?.name ?? "Unknown"
        let username = users.first(where: { $0.id == review.userId })?.username ?? "Unknown"

        cell.configure(
            restaurant: restaurantName,
            ratingFormatted: "\(review.rating)/5",
            comment: review.comment,
            username: "Created by: \(username)"
        )

        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let review = reviews[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.didSelectReview(review, from: self)
    }
}
