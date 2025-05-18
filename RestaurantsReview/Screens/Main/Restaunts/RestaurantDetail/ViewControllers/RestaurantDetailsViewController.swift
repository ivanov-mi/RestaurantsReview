//
//  RestaurantDetailsViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

// MARK: - RestaurantDetailsViewControllerDelegate
protocol RestaurantDetailsViewControllerDelegate: AnyObject {
    func didUpdateRestaurant()
}

// MARK: - RestaurantDetailsViewControllerCoordinator
protocol RestaurantDetailsViewControllerCoordinator: AnyObject {
    func didTapAddReview(_ controller: RestaurantDetailsViewController, for restaurant: Restaurant)
}

// MARK: - RestaurantDetailsViewController
class RestaurantDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var restaurantImageView: UIImageView!
    @IBOutlet weak private var restaurantNameLabel: UILabel!
    @IBOutlet weak private var cuisineDescriptionLabel: UILabel!

    @IBOutlet weak private var ratingContentView: UIView!
    @IBOutlet weak private var currentRatingLabel: UILabel!
    @IBOutlet weak private var maxPossibleRatingLabel: UILabel!
    @IBOutlet weak private var starRatingView: StarRatingView!
    @IBOutlet weak private var totalRatesLabel: UILabel!

    @IBOutlet weak private var createReviewButton: UIButton!

    @IBOutlet weak private var emptyRatingLabel: UILabel!
    @IBOutlet weak private var reviewsStackView: UIStackView!
    
    // MARK: - Properties
    private(set) var restaurant: Restaurant!
    var persistenceManager: PersistenceManaging!
    
    weak var coordinator: RestaurantDetailsViewControllerCoordinator?
    weak var delegate: RestaurantDetailsViewControllerDelegate?
    
    // MARK: - Public methods
    func configure(wtih restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    // MARK: - Actions
    
    @IBAction private func rateAndReviewButtonTapped(_ sender: Any) {
        guard let restaurant = restaurant else { return }
        
        coordinator?.didTapAddReview(self, for: restaurant)
    }

    // MARK: - Populate Data
    private func populateData() {
        configureImage(from: restaurant.imagePath)
        configureText(name: restaurant.name, cuisine: restaurant.cuisine)
        
        let reviews = persistenceManager.fetchReviews(for: restaurant.id)
        configureReviews(for: reviews)
        
        let averageRating = persistenceManager.averageRating(for: restaurant.id)
        configureRating(averageRating, reviewCount: reviews.count)
    }

    // MARK: - Image
    private func configureImage(from imagePath: String?) {
        restaurantImageView.image = imagePath.flatMap(UIImage.init(named:)) ?? UIImage(systemName: "photo")
    }

    // MARK: - Rating
    private func configureRating(_ rating: Double?, reviewCount: Int) {
        if let rating = rating {
            showRatingDetails(rating)
        } else {
            hideRatingDetails()
        }
        totalRatesLabel.text = "\(reviewCount) rating\(reviewCount == 1 ? "" : "s")"
    }

    private func showRatingDetails(_ rating: Double) {
        currentRatingLabel.text = String(format: "%.1f", rating)
        maxPossibleRatingLabel.text = "out of 5"
        starRatingView.setRating(rating)
        
        starRatingView.isUserInteractionEnabled = false
        ratingContentView.isHidden = false
        emptyRatingLabel.isHidden = true
    }

    private func hideRatingDetails() {
        ratingContentView.isHidden = true
        emptyRatingLabel.text = "Not rated yet"
        emptyRatingLabel.isHidden = false
    }

    // MARK: - Static Text
    private func configureText(name: String, cuisine: String) {
        restaurantNameLabel.text = name
        cuisineDescriptionLabel.text = cuisine
    }

    // MARK: - Reviews
    private func configureReviews(for reviews: [Review]) {
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !reviews.isEmpty else {
            reviewsStackView.isHidden = true
            return
        }

        reviewsStackView.isHidden = false

        let roles = determineReviewRoles(for: reviews)
        addReviewViews(for: roles)
    }

    private func determineReviewRoles(for reviews: [Review]) -> [Review: Set<ReviewListItemType>] {
        var roles: [Review: Set<ReviewListItemType>] = [:]

        if let mostRecent = reviews.max(by: { $0.dateCreated < $1.dateCreated }) {
            roles[mostRecent, default: []].insert(.mostRecent)
        }

        if let lowest = reviews.min(by: { $0.rating < $1.rating }) {
            roles[lowest, default: []].insert(.lowestRated)
        }

        if let highest = reviews.max(by: { $0.rating < $1.rating }) {
            roles[highest, default: []].insert(.highestRated)
        }

        return roles
    }

    private func addReviewViews(for roles: [Review: Set<ReviewListItemType>]) {
        for (review, tags) in roles {
            let view = ReviewListItemView()
            let ratingFormatted = "\(review.rating) / 5"
            view.configure(tags: tags, ratingFormatted: ratingFormatted, comment: review.comment)
            reviewsStackView.addArrangedSubview(view)
        }
    }
}

// MARK: - CreateReviewViewControllerDelegate
extension RestaurantDetailsViewController: CreateReviewViewControllerDelegate {
    func didSubmitReview() {
        populateData()
        delegate?.didUpdateRestaurant()
    }
}
