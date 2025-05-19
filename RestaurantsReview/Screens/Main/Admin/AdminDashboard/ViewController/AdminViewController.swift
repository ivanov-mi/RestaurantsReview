//
//  AdminViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - AdminViewControllerDCoordinator
protocol AdminViewControllerCoordinator: AnyObject {
    func didSelectRestaurants(from controller: AdminViewController)
    func didSelectUsers(from controller: AdminViewController)
    func didSelectReviews(from controller: AdminViewController)
}

// MARK: - AdminViewController
class AdminViewController: UITableViewController {

    // MARK: - Properties
    weak var coordinator: AdminViewControllerCoordinator?

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin"

        tableView.register(AdminItemTableViewCell.nib, forCellReuseIdentifier: AdminItemTableViewCell.identifier)
    }

    // MARK: - Table Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdminRow.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = AdminRow(rawValue: indexPath.row),
            let cell = tableView.dequeueReusableCell(withIdentifier: AdminItemTableViewCell.identifier, for: indexPath) as? AdminItemTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configure(with: row.title)
        return cell
    }

    // MARK: - Table Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = AdminRow(rawValue: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)

        switch row {
        case .restaurants:
            coordinator?.didSelectRestaurants(from: self)
        case .users:
            coordinator?.didSelectUsers(from: self)
        case .reviews:
            coordinator?.didSelectReviews(from: self)
        }
    }
}


enum AdminRow: Int, CaseIterable {
    case restaurants
    case users
    case reviews

    var title: String {
        switch self {
        case .restaurants: return "Restaurants"
        case .users: return "Users"
        case .reviews: return "Reviews"
        }
    }
}
