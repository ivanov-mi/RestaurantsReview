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
    func didTapLogout(_ controller: RestaurantListViewController)
}

// MARK: - RestaurantListViewController
class RestaurantListViewController: UITableViewController {
    
    // MARK: - Properties
    weak var coordinator: RestaurantListViewControllerCoordinator?
    
    private(set) var persistenceManager = PersistenceManager.shared
    private var restaurants: [Restaurant] = []

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadData()
    }
    
    func loadData() {
        restaurants = persistenceManager.fetchAllRestaurants()
        tableView.reloadData()
    }
    
    // MARK: - Setup UI
    private func configureView() {
        title = "Restaurants"
        
        // TODO: Remove after adding a proper logout UX
        
        addLogoutBarButton()
        
        tableView.separatorStyle = .none
        tableView.register(RestaurantListTableViewCell.nib, forCellReuseIdentifier: RestaurantListTableViewCell.identifier)
    }
    
    private func addLogoutBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }
    
    // MARK: - Actions
    @objc private func logoutTapped() {
        coordinator?.didTapLogout(self)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListTableViewCell.identifier, for: indexPath) as! RestaurantListTableViewCell
        let restaurant = restaurants[indexPath.row]
        
        let name = restaurant.name
        let rating = restaurant.rating.map { String(format: "%.1f", $0) } ?? "Not rated"
        let image = restaurant.imagePath.flatMap { UIImage(named: $0) }

        cell.configure(name: name, rating: rating, image: image)

        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        coordinator?.didSelectRestaurant(self, restaurant: restaurant)
    }
}

// MARK: - RestaurantDetailsViewControllerDelegate
extension RestaurantListViewController: RestaurantDetailsViewControllerDelegate {
    func didUpdateRestaurant(_ restaurant: Restaurant) {
        if let index = restaurants.firstIndex(where: { $0.name == restaurant.name }) {
            restaurants[index] = restaurant
            tableView.reloadData()
        }
    }
}
