//
//  ProfileDetailsTableViewCell.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import UIKit

class ProfileDetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    
    // MARK: - Configuration
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
