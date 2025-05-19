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

// MARK: - EditRestaurantViewControllerCoordinator
protocol EditRestaurantViewControllerCoordinator: AnyObject {
    func didFinishEditingRestaurant(_ controller: EditRestaurantViewController)
}

// MARK: - EditRestaurantViewControllerDelegate
protocol EditRestaurantViewControllerDelegate: AnyObject {
    func editedRestaurant(_ controller: EditRestaurantViewController)
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
    weak var coordinator: EditRestaurantViewControllerCoordinator?
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
        configureField(restaurantNameField, placeholder: "Name")
        configureField(cuisineField, placeholder: "Cuisine")
        configureField(imagePathField, placeholder: "Image name (optional)")

        if case let .edit(existing) = mode {
            restaurantNameField?.text = existing.name
            cuisineField?.text = existing.cuisine
            imagePathField?.text = existing.imagePath
        }
    }

    private func configureField(_ field: UITextField?, placeholder: String) {
        field?.placeholder = placeholder
        field?.borderStyle = .roundedRect
        field?.text = ""
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
        
        guard let _ = createOrUpdateRestaurant(name: name, cuisine: cuisine) else {
            showAlert(message: "Failed to create restaurant.")
            return
        }

        delegate?.editedRestaurant(self)
        coordinator?.didFinishEditingRestaurant(self)
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
