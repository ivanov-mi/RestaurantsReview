//
//  RestaurantListTableViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import UIKit

// MARK: - RestaurantListViewControllerCoordinator
protocol RestaurantListViewControllerCoordinator: AnyObject {
    func didSelectRestaurant(_ controller: RestaurantListViewController, restaurant: Restaurant)
    func didTapAddRestaurant(_ controller: RestaurantListViewController)
}

// MARK: - RestaurantListViewController
class RestaurantListViewController: UITableViewController {
    
    // MARK: - Properties
    weak var coordinator: RestaurantListViewControllerCoordinator?
    var persistenceManager: PersistenceManaging!
    
    private var restaurants: [Restaurant] = []
    private var selectedRestaurants: Set<UUID> = []
    
    private var editButton: UIBarButtonItem!
    private var doneButton: UIBarButtonItem!
    private var deleteButton: UIBarButtonItem!
    private var addButton: UIBarButtonItem!
    
    var sessionManager: SessionManaging = SessionManager.shared
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupAdminNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationButtons()
        reloadRestaurantList()
    }
    
    func reloadRestaurantList() {
        restaurants = persistenceManager.fetchAllRestaurants()
        tableView.reloadData()
    }
    
    // MARK: - Setup UI
    private func configureView() {
        title = "Restaurants"
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorStyle = .none
        tableView.register(RestaurantListTableViewCell.nib, forCellReuseIdentifier: RestaurantListTableViewCell.identifier)
    }
    
    private func setupAdminNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditMode))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(toggleEditMode))
        deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedTapped))
        deleteButton.tintColor = .systemRed
        deleteButton.isEnabled = false
        
        navigationItem.rightBarButtonItems = [addButton ,editButton]
    }
    
    private func updateNavigationButtons() {
        guard sessionManager.isAdmin else {
            navigationItem.rightBarButtonItems = nil
            if isEditing {
                setEditing(false, animated: true)
            }
            return
        }
        
        if isEditing {
            navigationItem.rightBarButtonItems = [deleteButton, doneButton]
        } else {
            navigationItem.rightBarButtonItems = [addButton, editButton]
        }
    }
    
    // MARK: - Actions
    @objc private func addTapped() {
        coordinator?.didTapAddRestaurant(self)
    }
    
    @objc private func toggleEditMode() {
        let updatedEditingState = !isEditing
        setEditing(updatedEditingState, animated: true)
        selectedRestaurants.removeAll()
        tableView.setEditing(updatedEditingState, animated: true)
        deleteButton.isEnabled = false
        updateNavigationButtons()
    }
    
    @objc private func deleteSelectedTapped() {
        let count = selectedRestaurants.count
        let label = count == 1 ? "restaurant" : "restaurants"
        let alert = UIAlertController(
            title: "Confirm Deletion",
            message: "Are you sure you want to delete \(count) \(label)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteSelectedRestaurants()
        })
        
        present(alert, animated: true)
    }
    
    private func deleteSelectedRestaurants() {
        let idsToDelete = selectedRestaurants
        persistenceManager.deleteRestaurants(restaurantIds: Array(idsToDelete))
        restaurants.removeAll { idsToDelete.contains($0.id) }
        tableView.reloadData()
        selectedRestaurants.removeAll()
        deleteButton.isEnabled = false
    }
    
    private func deleteRestaurant(at indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        persistenceManager.deleteRestaurant(restaurantId: restaurant.id)
        restaurants.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListTableViewCell.identifier, for: indexPath) as! RestaurantListTableViewCell
        let restaurant = restaurants[indexPath.row]
        
        let name = restaurant.name
        let rating = persistenceManager.averageRating(for: restaurant.id).map { String(format: "%.1f", $0) } ?? "Not rated"
        let image = restaurant.imagePath.flatMap { UIImage(named: $0) }
        cell.configure(name: name, rating: rating, image: image)
        
        return cell
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        
        if isEditing {
            selectedRestaurants.insert(restaurant.id)
            deleteButton.isEnabled = !selectedRestaurants.isEmpty
        } else {
            coordinator?.didSelectRestaurant(self, restaurant: restaurant)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard isEditing else { return }
        selectedRestaurants.remove(restaurants[indexPath.row].id)
        deleteButton.isEnabled = !selectedRestaurants.isEmpty
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard sessionManager.isAdmin else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteRestaurant(at: indexPath)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - RestaurantDetailsViewControllerDelegate
extension RestaurantListViewController: RestaurantDetailsViewControllerDelegate {
    func didUpdateRestaurant() {
        reloadRestaurantList()
    }
}

// MARK: - EditRestaurantViewControllerDelegate
extension RestaurantListViewController: EditRestaurantViewControllerDelegate {
    func editedRestaurant(_ controller: EditRestaurantViewController) {
        reloadRestaurantList()
    }
}
