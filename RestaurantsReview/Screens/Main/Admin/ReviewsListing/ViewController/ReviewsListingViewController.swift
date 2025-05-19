//
//  ReviewsListingViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

import UIKit

// MARK: - ReviewsListingViewControllerCoordinator
protocol ReviewsListingViewControllerCoordinator: AnyObject {
    func didSelectReview(_ controller: ReviewsListingViewController, review: Review)
}

// MARK: - ReviewsListingViewController
class ReviewsListingViewController: UITableViewController {

    // MARK: - Properties
    weak var coordinator: ReviewsListingViewControllerCoordinator?
    var persistenceManager: PersistenceManaging!
    private var reviews: [Review] = []
    private var restaurants: [Restaurant] = []
    private var users: [User] = []
    private var selectedReviews: Set<UUID> = []

    private var editButton: UIBarButtonItem!
    private var doneButton: UIBarButtonItem!
    private var deleteButton: UIBarButtonItem!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"

        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(ReviewsListingTableViewCell.nib, forCellReuseIdentifier: ReviewsListingTableViewCell.identifier)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadReviews()
    }

    // MARK: - Data
    private func reloadReviews() {
        reviews = persistenceManager.fetchAllReviews()
        restaurants = persistenceManager.fetchAllRestaurants()
        users = persistenceManager.fetchAllUsers()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toggleEditMode))
        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedTapped))
        deleteButton.tintColor = .systemRed
        deleteButton.isEnabled = false

        navigationItem.rightBarButtonItems = [editButton]
    }
    
    @objc private func toggleEditMode() {
        let updatedEditingState = !isEditing
        setEditing(updatedEditingState, animated: true)

        if updatedEditingState {
            selectedReviews.removeAll()
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItems = [deleteButton, doneButton]
            deleteButton.isEnabled = false
        } else {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItems = [editButton]
        }
    }
    
    @objc private func deleteSelectedTapped() {
        let count = selectedReviews.count
        let label = count == 1 ? "review" : "reviews"
        let alert = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete \(count) \(label)?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteSelectedReviews()
        })

        present(alert, animated: true)
    }

    private func deleteSelectedReviews() {
        let idsToDelete = selectedReviews
        persistenceManager.deleteReviews(reviewIds: Array(idsToDelete))
        reviews.removeAll { idsToDelete.contains($0.id) }
        tableView.reloadData()
        selectedReviews.removeAll()
        deleteButton.isEnabled = false
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

        if isEditing {
            selectedReviews.insert(review.id)
            deleteButton.isEnabled = !selectedReviews.isEmpty
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            coordinator?.didSelectReview(self, review: review)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard isEditing else { return }
        selectedReviews.remove(reviews[indexPath.row].id)
        deleteButton.isEnabled = !selectedReviews.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteReview(at: indexPath)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func deleteReview(at indexPath: IndexPath) {
        let review = reviews[indexPath.row]
        persistenceManager.deleteReview(reviewId: review.id)
        reviews.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ReviewsListingViewController: CreateReviewViewControllerDelegate {
    func didSubmitReview() {
        reloadReviews()
    }
}
