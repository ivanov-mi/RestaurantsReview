//
//  ReviewsListingTableViewCell.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

import UIKit

class ReviewsListingTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var restaurantLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    // MARK: - Configuration
    func configure(restaurant: String, ratingFormatted: String, comment: String, username: String) {
        self.restaurantLabel.text = restaurant
        self.ratingLabel.text = ratingFormatted
        self.commentLabel.text = comment
        self.usernameLabel.text = username
    }
}
