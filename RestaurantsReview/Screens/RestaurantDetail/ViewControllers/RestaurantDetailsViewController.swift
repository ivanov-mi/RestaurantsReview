//
//  RestaurantDetailsViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/13/25.
//

import UIKit

protocol RestaurantDetailsViewControllerDelegate: AnyObject {
    func didUpdateRestaurant(_ restaurant: Restaurant)
}

class RestaurantDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var restaurant: Restaurant?
    
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
    
    weak var delegate: RestaurantDetailsViewControllerDelegate?
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    // MARK: - Actions
    
    @IBAction private func rateAndReviewButtonTapped(_ sender: Any) {
        presentReviewForm()
    }

    // MARK: - Populate Data
    private func populateData() {
        guard let restaurant = restaurant else { return }

        configureImage(from: restaurant.imagePath)
        configureRating(restaurant.rating, reviewCount: restaurant.reviews.count)
        configureText(name: restaurant.name, cuisine: restaurant.cuisine)
        configureReviews(from: restaurant)
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
    private func configureReviews(from restaurant: Restaurant) {
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !restaurant.reviews.isEmpty else {
            reviewsStackView.isHidden = true
            return
        }

        reviewsStackView.isHidden = false

        let roles = determineReviewRoles(from: restaurant)
        addReviewViews(for: roles)
    }

    private func determineReviewRoles(from restaurant: Restaurant) -> [Review: Set<ReviewListItemType>] {
        var roles: [Review: Set<ReviewListItemType>] = [:]

        if let mostRecent = restaurant.latestReview {
            roles[mostRecent, default: []].insert(.mostRecent)
        }

        if let lowest = restaurant.lowestRated {
            roles[lowest, default: []].insert(.lowestRated)
        }

        if let highest = restaurant.highestRated {
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
    
    // MARK: - Navigation
    private func presentReviewForm() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let createReviewVC = storyboard.instantiateViewController(withIdentifier: "CreateReviewViewController") as? CreateReviewViewController {
            
            // TODO: Fix user identity
            
            createReviewVC.userId = UUID()
            createReviewVC.delegate = self
            let navController = UINavigationController(rootViewController: createReviewVC)
            present(navController, animated: true)
        }
    }
}

// MARK: - CreateReviewViewControllerDelegate
extension RestaurantDetailsViewController: CreateReviewViewControllerDelegate {
    
    func didSubmitReview(_ review: Review) {
        restaurant?.reviews.append(review)
        populateData()
        
        if let restaurant {
            delegate?.didUpdateRestaurant(restaurant)
        }
    }
}
