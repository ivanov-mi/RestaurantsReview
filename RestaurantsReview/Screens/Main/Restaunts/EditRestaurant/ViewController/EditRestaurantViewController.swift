//
//  EditRestaurantViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/19/25.
//

import UIKit

// MARK: - EditRestaurantMode
enum EditRestaurantMode {
    case create
    case edit(existing: Restaurant)
    
    var title: String {
        switch self {
        case .create: return "Add Restaurant"
        case .edit: return "Edit Restaurant"
        }
    }
}

// MARK: - EditRestaurantViewControllerDelegate
protocol EditRestaurantViewControllerDelegate: AnyObject {
    func didSaveRestaurant(_ restaurant: Restaurant, from controller: EditRestaurantViewController)
}

// MARK: - EditRestaurantViewController
class EditRestaurantViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var restaurantNameField: UITextField?
    @IBOutlet weak private var cuisineField: UITextField?
    @IBOutlet weak private var imagePathField: UITextField?
    
    // MARK: - Properties
    var persistenceManager: PersistenceManaging!
    weak var delegate: EditRestaurantViewControllerDelegate?
    var mode: EditRestaurantMode = .create

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = mode.title
        view.backgroundColor = .systemBackground
        setupForm()
        setupNavigationBar()
        populateFields()
    }

    // MARK: - Setup UI
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
    }

    private func setupForm() {
        restaurantNameField?.text = ""
        restaurantNameField?.placeholder = "Name"
        
        cuisineField?.text = ""
        cuisineField?.placeholder = "Cuisine"
        
        imagePathField?.text = ""
        imagePathField?.placeholder = "Image name (optional)"
        
        for field in [restaurantNameField, cuisineField, imagePathField] {
            field?.borderStyle = .roundedRect
        }
    }

    private func populateFields() {
        if case let .edit(existing) = mode {
            restaurantNameField?.text = existing.name
            cuisineField?.text = existing.cuisine
            imagePathField?.text = existing.imagePath
        }
    }

    // MARK: - Actions
    @objc private func saveTapped() {
        guard let name = restaurantNameField?.text, !name.isEmpty,
            let cuisine = cuisineField?.text, !cuisine.isEmpty
        else {
            showAlert(message: "Please fill in name and cuisine.")
            return
        }
        
        guard let restaurant = createOrUpdateRestaurant(name: name, cuisine: cuisine) else {
            showAlert(message: "Failed to create restaurant.")
            return
        }

        delegate?.didSaveRestaurant(restaurant, from: self)
    }
    
    // MARK: - Private helpers
    private func createOrUpdateRestaurant(name: String, cuisine: String) -> Restaurant? {
        let imagePath = imagePathField?.text == "" ? nil : imagePathField?.text

        switch mode {
        case .create:
            return persistenceManager.createRestaurant(name: name, cuisine: cuisine, imagePath: imagePath)
        case .edit(let existing):
            let updatedRestaurant = Restaurant(id: existing.id, name: name, cuisine: cuisine, imagePath: imagePath)
            persistenceManager.updateRestaurant(updatedRestaurant)
            return updatedRestaurant
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
