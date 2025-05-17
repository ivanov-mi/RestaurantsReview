//
//  RestaurantListTableViewCell.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import UIKit

class RestaurantListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var restaurantImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        applyShadowStyling()
    }
    
    // MARK: - Configuration
    func configure(name: String, rating: String, image: UIImage?) {
        nameLabel.text = name
        ratingLabel.text = rating
        restaurantImageView.image = image ?? UIImage(systemName: "photo")
    }
    

    // MARK: - Shadow Styling
    private func applyShadowStyling() {
        self.applyDefaultShadow()
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
    }
}
