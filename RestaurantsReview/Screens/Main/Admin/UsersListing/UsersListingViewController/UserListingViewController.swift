//
//  UserListingViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

import UIKit

// MARK: - UserListingViewControllerCoordinator
protocol UserListingViewControllerCoordinator: AnyObject {
    func didSelectUser(_ controller: UserListingViewController, user: User)
    func currentUserDeleted(_ controller: UserListingViewController)
    func didTapAddUser(_ controller: UserListingViewController)
}

// MARK: - View Controller
class UserListingViewController: UITableViewController {
    
    // MARK: - Properties
    weak var coordinator: UserListingViewControllerCoordinator?
    var persistenceManager: PersistenceManaging!
    var sessionManager: SessionManaging = SessionManager.shared
    
    private var users: [User] = []
    private var selectedUsers: Set<UUID> = []
    
    private var addButton: UIBarButtonItem!
    private var editButton: UIBarButtonItem!
    private var doneButton: UIBarButtonItem!
    private var deleteButton: UIBarButtonItem!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(UserListingTableViewCell.nib, forCellReuseIdentifier: UserListingTableViewCell.identifier)
        
        setupNavigationBar()
        reloadUsers()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserTapped))
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toggleEditMode))
        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedTapped))
        deleteButton.tintColor = .systemRed
        deleteButton.isEnabled = false
        
        navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    private func reloadUsers() {
        users = persistenceManager.fetchAllUsers()
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func addUserTapped() {
        coordinator?.didTapAddUser(self)
    }
    
    @objc private func toggleEditMode() {
        let updatedEditingState = !isEditing
        setEditing(updatedEditingState, animated: true)
        
        if updatedEditingState {
            selectedUsers.removeAll()
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItems = [deleteButton, doneButton]
            deleteButton.isEnabled = false
        } else {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItems = [addButton, editButton]
        }
    }
    
    @objc private func deleteSelectedTapped() {
        let alert = createDeleteConfirmationAlert(for: selectedUsers.count) { [weak self] _ in
            self?.deleteUsers()
        }
        present(alert, animated: true)
    }
    
    
    // MARK: - Private methods
    private func updateDeleteButtonState() {
        deleteButton.isEnabled = !selectedUsers.isEmpty
    }
    
    private func makeDeleteSwipeAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self else {
                completion(false)
                return
            }
            self.deleteUser(at: indexPath)
            completion(true)
        }
    }
    
    private func createDeleteConfirmationAlert(for numberOfUsers: Int, completionHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let userLabel = numberOfUsers == 1 ? "user" : "users"
        let message = "Are you sure you want to delete \(numberOfUsers) \(userLabel)?"
        
        let alert = UIAlertController(
            title: "Confirm Deletion",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: completionHandler))
        
        return alert
    }
    
    // MARK: Delete users
    private func deleteUser(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        persistenceManager.deleteUser(userId: user.id)
        users.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if sessionManager.currentUser?.id == user.id {
            coordinator?.currentUserDeleted(self)
        }
    }
    
    private func deleteUsers() {
        let userIds = users.filter { selectedUsers.contains($0.id) }.map { $0.id }
        persistenceManager.deleteUsers(userIds: userIds)
        users.removeAll { selectedUsers.contains($0.id) }
        tableView.reloadData()
        selectedUsers.removeAll()
        deleteButton.isEnabled = false
        
        if let currentUserId = sessionManager.currentUser?.id,
           userIds.contains(currentUserId) {
            coordinator?.currentUserDeleted(self)
        }
    }
    
    // MARK: - TableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListingTableViewCell.identifier, for: indexPath) as! UserListingTableViewCell
        cell.configure(username: user.username, isAdmin: user.isAdmin)
        return cell
    }
    
    // MARK: - TableView elegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            selectedUsers.insert(users[indexPath.row].id)
            updateDeleteButtonState()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            coordinator?.didSelectUser(self, user: users[indexPath.row])
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard isEditing else { return }
        selectedUsers.remove(users[indexPath.row].id)
        updateDeleteButtonState()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = makeDeleteSwipeAction(forRowAt: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - ProfileViewControllerDelegate
extension UserListingViewController: ProfileViewControllerDelegate {
    func didUpdateUser(_ controller: ProfileViewController) {
        reloadUsers()
    }
}

// MARK: - RegisterViewControllerDelegate
extension UserListingViewController: RegisterViewControllerDelegate {
    func didRegisterUser(_ controller: RegisterViewController, user: User) {
        reloadUsers()
    }
}
