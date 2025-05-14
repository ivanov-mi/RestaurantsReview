//
//  RestaurantListTableViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import UIKit

class RestaurantListViewController: UITableViewController {
    
    // TODO: Update after adding local persistance
    
    lazy var restaurants: [Restaurant] = {
        TestDataProvider.shared.sampleRestaurants
    }()

    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurants"

        tableView.register(RestaurantListTableViewCell.nib, forCellReuseIdentifier: RestaurantListTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    // MARK: Override
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListTableViewCell.identifier, for: indexPath) as! RestaurantListTableViewCell
        let restaurant = restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurant.name
        cell.ratingLabel.text = restaurant.rating.map { String(format: "%.1f", $0) } ?? "N/A"
        cell.restaurantImageView.image = restaurant.imagePath.flatMap { UIImage(named: $0) } ?? UIImage(systemName: "photo")

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailsViewController") as? RestaurantDetailsViewController {
            detailsVC.restaurant = restaurants[indexPath.row]
            detailsVC.delegate = self
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension RestaurantListViewController: RestaurantDetailsViewControllerDelegate {
    func didUpdateRestaurant(_ restaurant: Restaurant) {
        if let index = restaurants.firstIndex(where: { $0.name == restaurant.name }) {
            restaurants[index] = restaurant
            tableView.reloadData()
        }
    }
}
