//
//  RestaurantDetailsViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

class RestaurantDetailsViewController: UIViewController {
    
    var restaurant: Restaurant?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }

    private func populateData() {
        guard let restaurant = restaurant else { return }

        configureImage(from: restaurant.imagePath)
        configureRating(restaurant.rating)
        configureText(name: restaurant.name, cuisine: restaurant.cuisine)
        configureReviews(restaurant.reviews)
        totalRatesLabel.text = "\(restaurant.reviews.count)"
    }

    private func configureImage(from imagePath: String?) {
        restaurantImageView.image = imagePath.flatMap(UIImage.init(named:)) ?? UIImage(systemName: "photo")
    }

    private func configureRating(_ rating: Double?) {
        if let rating = rating {
            currentRatingLabel.text = String(format: "%.1f", rating)
            maxPossibleRatingLabel.text = "out of 5"
            starRatingView.rating = rating
            maxPossibleRatingLabel.isHidden = false
            emptyRatingLabel.isHidden = true
        } else {
            ratingContentView.isHidden = true
            maxPossibleRatingLabel.isHidden = false
            emptyRatingLabel.text = "Not rated yet"
        }
    }

    private func configureText(name: String, cuisine: String) {
        restaurantNameLabel.text = name
        cuisineDescriptionLabel.text = cuisine
    }

    private func configureReviews(_ reviews: [Review]) {
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !reviews.isEmpty else {
            reviewsStackView.isHidden = true
            return
        }

        reviewsStackView.isHidden = false

        guard let mostRecent = reviews.max(by: { $0.dateOfVisit < $1.dateOfVisit }),
            let lowest = reviews.min(by: { $0.rating < $1.rating }),
            let highest = reviews.max(by: { $0.rating < $1.rating })
        else { return }

        var roles: [Review: Set<ReviewListItemType>] = [:]

        for (review, role) in [
            (mostRecent, ReviewListItemType.mostRecent),
            (lowest, ReviewListItemType.lowestRated),
            (highest, ReviewListItemType.highestRated)
        ] {
            roles[review, default: []].insert(role)
        }

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
