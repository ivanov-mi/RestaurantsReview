//
//  UserListingViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

import UIKit

// MARK: - UserListingViewControllerCoordinator
protocol UserListingViewControllerCoordinator: AnyObject {
    func didSelectUser(_ user: User, from controller: UserListingViewController)
}

// MARK: - UserListingViewController
class UserListingViewController: UITableViewController {
    
    // MARK: - Properties
    weak var coordinator: UserListingViewControllerCoordinator?
    var persistenceManager: PersistenceManaging!
    private var users: [User] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        
        tableView.register(UserListingTableViewCell.nib, forCellReuseIdentifier: UserListingTableViewCell.identifier)
        tableView.backgroundColor = .systemGroupedBackground
        loadUsers()
    }
    
    // MARK: - Data
    private func loadUsers() {
        users = persistenceManager.fetchAllUsers()
        tableView.reloadData()
    }
    
    // MARK: - Table Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListingTableViewCell", for: indexPath) as! UserListingTableViewCell
        let user = users[indexPath.row]
        cell.configure(username: user.username, isAdmin: user.isAdmin)
        return cell
    }
    
    // MARK: - Table Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.didSelectUser(user, from: self)
    }
}
