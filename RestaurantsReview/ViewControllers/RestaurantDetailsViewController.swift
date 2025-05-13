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
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var cuisineDescriptionLabel: UILabel!
    
    @IBOutlet weak var ratingContentView: UIView!
    @IBOutlet weak var currentRatingLabel: UILabel!
    @IBOutlet weak var maxPossibleRatingLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var totalRatesLabel: UILabel!
    
    @IBOutlet weak var createReviewButton: UIButton!
    
    @IBOutlet weak var emptyRatingLabel: UILabel!
    @IBOutlet weak var reviewsStackView: UIStackView!
    
    weak var delegate: RestaurantDetailsViewControllerDelegate?
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    @IBAction func rateAndReviewButtonTapped(_ sender: Any) {
        presentReviewForm() 
    }
}

private extension RestaurantDetailsViewController {

    // MARK: - Populate Data
    func populateData() {
        guard let restaurant = restaurant else { return }

        configureImage(from: restaurant.imagePath)
        configureRating(restaurant.rating, reviewCount: restaurant.reviews.count)
        configureText(name: restaurant.name, cuisine: restaurant.cuisine)
        configureReviews(from: restaurant)
    }

    // MARK: - Image
    func configureImage(from imagePath: String?) {
        restaurantImageView.image = imagePath.flatMap(UIImage.init(named:)) ?? UIImage(systemName: "photo")
    }

    // MARK: - Rating
    func configureRating(_ rating: Double?, reviewCount: Int) {
        if let rating = rating {
            showRatingDetails(rating)
        } else {
            hideRatingDetails()
        }
        totalRatesLabel.text = "\(reviewCount) rating\(reviewCount == 1 ? "" : "s")"
    }

    func showRatingDetails(_ rating: Double) {
        currentRatingLabel.text = String(format: "%.1f", rating)
        maxPossibleRatingLabel.text = "out of 5"
        starRatingView.setRating(rating)
        
        starRatingView.isUserInteractionEnabled = false
        ratingContentView.isHidden = false
        emptyRatingLabel.isHidden = true
    }

    func hideRatingDetails() {
        ratingContentView.isHidden = true
        emptyRatingLabel.text = "Not rated yet"
        emptyRatingLabel.isHidden = false
    }

    // MARK: - Static Text
    func configureText(name: String, cuisine: String) {
        restaurantNameLabel.text = name
        cuisineDescriptionLabel.text = cuisine
    }

    // MARK: - Reviews
    func configureReviews(from restaurant: Restaurant) {
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !restaurant.reviews.isEmpty else {
            reviewsStackView.isHidden = true
            return
        }

        reviewsStackView.isHidden = false

        let roles = determineReviewRoles(from: restaurant)
        addReviewViews(for: roles)
    }

    func determineReviewRoles(from restaurant: Restaurant) -> [Review: Set<ReviewListItemType>] {
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

    func addReviewViews(for roles: [Review: Set<ReviewListItemType>]) {
        for (review, tags) in roles {
            let view = ReviewListItemView()
            view.configure(with: ReviewListItemViewModel(
                tags: tags,
                rating: review.rating,
                comment: review.comment
            ))
            
            reviewsStackView.addArrangedSubview(view)
        }
    }
}

extension RestaurantDetailsViewController: CreateReviewViewControllerDelegate {
    func didCancelReview() {
        print("Submition caneeled")
    }
    
    func didSubmitReview(_ review: Review) {
        restaurant?.reviews.append(review)
        populateData()
        
        if let restaurant {
            delegate?.didUpdateRestaurant(restaurant)
        }
    }

    @objc func presentReviewForm() {
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

