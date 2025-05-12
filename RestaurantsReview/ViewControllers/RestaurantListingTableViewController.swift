//
//  RestaurantListingTableViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import UIKit

class RestaurantListViewController: UITableViewController {
    var restaurants: [Restaurant] = [
        Restaurant(name: "Sushi Place", cuisine: "Japanese", imagePath: "image1", reviews: [
            Review(authorID: UUID(), content: "Fresh and delicious sushi!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Great ambiance, but rolls were average.", rating: 3, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "The best sashimi I've ever had!", rating: 5, dateOfVisit: Date())
        ]),
        Restaurant(name: "Pasta Corner", cuisine: "Italian", imagePath: "image2", reviews: [
            Review(authorID: UUID(), content: "Authentic pasta, felt like Italy!", rating: 4, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Good food, but service was slow.", rating: 3, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Fantastic lasagna!", rating: 5, dateOfVisit: Date())
        ]),
        Restaurant(name: "BBQ Haven", cuisine: "American", imagePath: "image3", reviews: [
            Review(authorID: UUID(), content: "Best ribs ever!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "A bit too smoky for my taste.", rating: 3, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Amazing brisket!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Portions could be bigger.", rating: 4, dateOfVisit: Date())
        ]),
        Restaurant(name: "Curry Delight", cuisine: "Indian", imagePath: "image4", reviews: [
            Review(authorID: UUID(), content: "Spices hit perfectly!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Authentic flavors, loved the naan!", rating: 4, dateOfVisit: Date())
        ]),
        Restaurant(name: "Taco Fiesta", cuisine: "Mexican", imagePath: "image5", reviews: [
            Review(authorID: UUID(), content: "Authentic street tacos.", rating: 4, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "The best carnitas in town!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Salsa was a bit too spicy for me.", rating: 3, dateOfVisit: Date())
        ]),
        Restaurant(name: "Steakhouse Supreme", cuisine: "American", imagePath: "image6", reviews: [
            Review(authorID: UUID(), content: "Perfectly cooked steak!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Good selection, but a bit pricey.", rating: 4, dateOfVisit: Date())
        ]),
        Restaurant(name: "Dim Sum Delight", cuisine: "Chinese", imagePath: "image7", reviews: [
            Review(authorID: UUID(), content: "Best dumplings in town!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Loved the variety of dim sum.", rating: 4, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Service was slow, but food was great!", rating: 3, dateOfVisit: Date())
        ]),
        Restaurant(name: "Greek Taverna", cuisine: "Greek", imagePath: "image8", reviews: [
            Review(authorID: UUID(), content: "Amazing souvlaki and feta salad!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Authentic Greek flavors!", rating: 4, dateOfVisit: Date())
        ]),
        Restaurant(name: "Bakery Bliss", cuisine: "French", imagePath: "image9", reviews: [
            Review(authorID: UUID(), content: "Best croissants I've ever had!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Great selection of pastries.", rating: 4, dateOfVisit: Date())
        ]),
        Restaurant(name: "Japanese Ramen House", cuisine: "Japanese", imagePath: "image10", reviews: [
            Review(authorID: UUID(), content: "Rich, flavorful broth!", rating: 5, dateOfVisit: Date()),
            Review(authorID: UUID(), content: "Authentic ramen experience.", rating: 4, dateOfVisit: Date())
        ])
    ]



    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurants"

        tableView.register(RestaurantListTableViewCell.nib, forCellReuseIdentifier: RestaurantListTableViewCell.identifier)
        
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListTableViewCell.identifier, for: indexPath) as! RestaurantListTableViewCell
        let restaurant = restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurant.name
        if let rating = restaurant.rating {
            cell.ratingLabel.text = String(format: "%.1f", rating)
        } else {
            cell.ratingLabel.text = "N/A"
        }
        
        if let imagePath = restaurant.imagePath {
            cell.restaurantImageView.image = UIImage(named: imagePath)
        }  else {
            cell.restaurantImageView.image = UIImage(systemName: "photo")
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailsViewController") as? RestaurantDetailsViewController {
            detailsVC.restaurant = restaurants[indexPath.row]
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
