//
//  ProfileSwitchTableViewCell.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import UIKit

// MARK: - ProfileSwitchTableViewCellDelegate
protocol ProfileSwitchTableViewCellDelegate: AnyObject {
    func profileSwitchCell(_ cell: ProfileSwitchTableViewCell, didChangeValue isOn: Bool)
}

// MARK: - ProfileSwitchTableViewCell
class ProfileSwitchTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var toggleSwitch: UISwitch!
    
    // MARK: - Properties
    weak var delegate: ProfileSwitchTableViewCellDelegate?

    // MARK: - Configuration
    func configure(title: String, isOn: Bool) {
        titleLabel.text = title
        toggleSwitch.isOn = isOn
        toggleSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }

    // MARK: - Actions
    @objc private func switchToggled() {
        let isOn = toggleSwitch.isOn
        delegate?.profileSwitchCell(self, didChangeValue: isOn)
    }
}
