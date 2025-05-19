//
//  UserListingTableViewCell.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import UIKit

class UserListingTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var adminStatusLabel: UILabel!
    
    // MARK: - Configuration
    func configure(username: String, isAdmin: Bool) {
        userNameLabel.text = username
        adminStatusLabel.isHidden = !isAdmin
        adminStatusLabel.text = "Admin"        
    }
}
