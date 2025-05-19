//
//  AdmintTableViewCell.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

import UIKit

class AdminItemTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Configuration
    func configure(with title: String) {
        titleLabel.text = title
    }
}
