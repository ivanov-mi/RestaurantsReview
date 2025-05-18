//
//  AdminViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - AdminViewControllerDelegate
protocol AdminViewControllerDelegate: AnyObject {
    func didSelectRestaurants(from controller: AdminViewController)
    func didSelectUsers(from controller: AdminViewController)
}

// MARK: - AdminViewController
class AdminViewController: UITableViewController {

    // MARK: - Properties
    weak var delegate: AdminViewControllerDelegate?

    enum Section: Int, CaseIterable {
        case main
    }

    enum Row: Int, CaseIterable {
        case restaurants
        case users

        var title: String {
            switch self {
            case .restaurants: return "Restaurants"
            case .users: return "Users"
            }
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin"

        tableView.register(AdminItemTableViewCell.nib, forCellReuseIdentifier: AdminItemTableViewCell.identifier)
    }

    // MARK: - Table Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard Section(rawValue: section) == .main else { return 0 }
        return Row.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let row = Row(rawValue: indexPath.row) else { return cell }

        cell.textLabel?.text = row.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Table Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = Row(rawValue: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)

        switch row {
        case .restaurants:
            delegate?.didSelectRestaurants(from: self)
        case .users:
            delegate?.didSelectUsers(from: self)
        }
    }
}

