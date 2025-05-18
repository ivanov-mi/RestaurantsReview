//
//  ProfileLogoutTableViewCell.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import UIKit

class ProfileLogoutTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var titleLabel: UILabel!

    // MARK: - Configuration
    func configure(title: String) {
        titleLabel.text = title
    }
}
