//
//  RestaurantDetailsViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

class RestaurantDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var restaurant: Restaurant?
    
    // MARK: - IBOutlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var cuisineDescriptionLabel: UILabel!
    
    @IBOutlet weak var ratingContentView: UIView!
    @IBOutlet weak var currentRatingLabel: UILabel!
    @IBOutlet weak var maxPossibleRatingLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var totalRatesLabel: UILabel!
    
    @IBOutlet weak var emptyRatingLabel: UILabel!
    @IBOutlet weak var reviewsStackView: UIStackView!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
}

private extension RestaurantDetailsViewController {

    // MARK: - Data Population
    func populateData() {
        guard let restaurant = restaurant else { return }

        configureImage(from: restaurant.imagePath)
        configureRating(restaurant.rating, reviewCount: restaurant.reviews.count)
        configureText(name: restaurant.name, cuisine: restaurant.cuisine)
        configureReviews(restaurant.reviews)
    }

    // MARK: - Configuration Methods
    func configureImage(from imagePath: String?) {
        restaurantImageView.image = imagePath.flatMap(UIImage.init(named:)) ?? UIImage(systemName: "photo")
    }

    func configureRating(_ rating: Double?, reviewCount: Int) {
        if let rating = rating {
            showRatingDetails(rating)
        } else {
            hideRatingDetails()
        }
        totalRatesLabel.text = "\(reviewCount) ratings"
    }

    func showRatingDetails(_ rating: Double) {
        currentRatingLabel.text = String(format: "%.1f", rating)
        maxPossibleRatingLabel.text = "out of 5"
        starRatingView.rating = rating
        ratingContentView.isHidden = false
        emptyRatingLabel.isHidden = true
    }

    func hideRatingDetails() {
        ratingContentView.isHidden = true
        emptyRatingLabel.text = "Not rated yet"
        emptyRatingLabel.isHidden = false
    }

    func configureText(name: String, cuisine: String) {
        restaurantNameLabel.text = name
        cuisineDescriptionLabel.text = cuisine
    }

    func configureReviews(_ reviews: [Review]) {
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        reviewsStackView.isHidden = reviews.isEmpty

        guard !reviews.isEmpty else { return }

        let roles = determineReviewRoles(from: reviews)
        addReviewViews(for: roles)
    }

    // MARK: - Helper Methods
    func determineReviewRoles(from reviews: [Review]) -> [Review: Set<ReviewListItemType>] {
        guard
            let mostRecent = reviews.max(by: { $0.dateOfVisit < $1.dateOfVisit }),
            let lowest = reviews.min(by: { $0.rating < $1.rating }),
            let highest = reviews.max(by: { $0.rating < $1.rating })
        else { return [:] }

        var roles: [Review: Set<ReviewListItemType>] = [:]

        for (review, role) in [
            (mostRecent, ReviewListItemType.mostRecent),
            (lowest, ReviewListItemType.lowestRated),
            (highest, ReviewListItemType.highestRated)
        ] {
            roles[review, default: []].insert(role)
        }

        return roles
    }

    func addReviewViews(for roles: [Review: Set<ReviewListItemType>]) {
        for (review, tags) in roles {
            let view = ReviewListItemView()
            view.configure(with: ReviewListItemViewModel(
                tags: tags,
                rating: review.rating,
                comment: review.content
            ))
            reviewsStackView.addArrangedSubview(view)
        }
    }
}
