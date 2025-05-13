//
//  RestaurantListingTableViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/12/25.
//

import UIKit

class RestaurantListViewController: UITableViewController {
    
    // MARK: Test Data
    var restaurants: [Restaurant] = [
        Restaurant(name: "Sushi Place", cuisine: "Japanese", imagePath: "image1", reviews: [
            Review(userId: UUID(), comment: "Fresh and delicious sushi!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Great ambiance, but rolls were average.", rating: 3, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "The best sashimi I've ever had!", rating: 5, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Pasta Corner", cuisine: "Italian", imagePath: "image2", reviews: [
            Review(userId: UUID(), comment: "Authentic pasta, felt like Italy!", rating: 4, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Good food, but service was slow.", rating: 3, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Fantastic lasagna!", rating: 5, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "BBQ Haven", cuisine: "American", imagePath: "image3", reviews: [
            Review(userId: UUID(), comment: "Best ribs ever!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "A bit too smoky for my taste.", rating: 3, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Amazing brisket!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Portions could be bigger.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Curry Delight", cuisine: "Indian", imagePath: "image4", reviews: [
            Review(userId: UUID(), comment: "Spices hit perfectly!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Authentic flavors, loved the naan!", rating: 4, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Taco Fiesta", cuisine: "Mexican", imagePath: "image5", reviews: [
            Review(userId: UUID(), comment: "Authentic street tacos.", rating: 4, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "The best carnitas in town!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
          Review(userId: UUID(), comment: "Salsa was a bit too spicy for me.", rating: 3, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Steakhouse Supreme", cuisine: "American", imagePath: "image6", reviews: [
            Review(userId: UUID(), comment: "Perfectly cooked steak!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Good selection, but a bit pricey.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Dim Sum Delight", cuisine: "Chinese", imagePath: "image7", reviews: [
            Review(userId: UUID(), comment: "Best dumplings in town!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Loved the variety of dim sum.", rating: 4, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Service was slow, but food was great!", rating: 3, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Greek Taverna", cuisine: "Greek", imagePath: "image8", reviews: [
            Review(userId: UUID(), comment: "Amazing souvlaki and feta salad!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Authentic Greek flavors!", rating: 4, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Bakery Bliss", cuisine: "French", imagePath: "image9", reviews: [
            Review(userId: UUID(), comment: "Best croissants I've ever had!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Great selection of pastries.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
        ]),
        Restaurant(name: "Japanese Ramen House", cuisine: "Japanese", imagePath: "image10", reviews: [
            Review(userId: UUID(), comment: "Rich, flavorful broth!", rating: 5, dateOfVisit: Date(), dateCreated: Date()),
            Review(userId: UUID(), comment: "Authentic ramen experience.", rating: 4, dateOfVisit: Date(), dateCreated: Date())
        ])
    ]
    
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
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
