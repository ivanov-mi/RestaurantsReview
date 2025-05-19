//
//  RestaurantListCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - RestaurantListCoordinator
class RestaurantListCoordinator: Coordinator {

    // MARK: - Properties
    private let navigationController: UINavigationController
    private let persistenceManager: PersistenceManaging

    // MARK: - Init
    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
    }

    // MARK: - Coordinator
    func start() {
        let listVC = AppStoryboard.main.viewController(ofType: RestaurantListViewController.self)
        listVC.coordinator = self
        listVC.persistenceManager = persistenceManager
        navigationController.setViewControllers([listVC], animated: false)
    }
    
    func pushRestaurantList(on navController: UINavigationController) {
        let listVC = AppStoryboard.main.viewController(ofType: RestaurantListViewController.self)
        listVC.coordinator = self
        listVC.persistenceManager = persistenceManager
        navigationController.pushViewController(listVC, animated: true)
    }
    
    func presentCreateReviewScreen(from controller: RestaurantDetailsViewController, for restaurant: Restaurant) {
        guard let user = SessionManager.shared.currentUser else {
            
            // TODO: Implement session error flow
            
            return
        }

        let createReviewVC = AppStoryboard.main.viewController(ofType: CreateReviewViewController.self)
        createReviewVC.configure(with: user.id, for: restaurant.id)
        createReviewVC.coordinator = self
        createReviewVC.persistenceManager = persistenceManager
        createReviewVC.delegate = controller

        let nav = UINavigationController(rootViewController: createReviewVC)
        controller.present(nav, animated: true)
    }
    
    func presentEditRestaurant(from controller: RestaurantDetailsViewController, restaurant: Restaurant) {
        let editVC = AppStoryboard.main.viewController(ofType: EditRestaurantViewController.self)
        editVC.mode = .edit(existing: restaurant)
        editVC.persistenceManager = persistenceManager
        editVC.delegate = controller
        editVC.coordinator = self
        
        let navigationController = UINavigationController(rootViewController: editVC)
        controller.present(navigationController, animated: true)
    }
    
    func presentCreateRestaurant(from controller: RestaurantListViewController) {
        let editVC = AppStoryboard.main.viewController(ofType: EditRestaurantViewController.self)
        editVC.persistenceManager = persistenceManager
        editVC.delegate = controller
        editVC.coordinator = self
        
        let navigationController = UINavigationController(rootViewController: editVC)
        controller.present(navigationController, animated: true)
    }
    
    func pushRestaurantDetails(_ restaurant: Restaurant, _ controller: RestaurantListViewController) {
        let restaurantDetailsVC = AppStoryboard.main.viewController(ofType: RestaurantDetailsViewController.self)
        restaurantDetailsVC.configure(wtih: restaurant)
        restaurantDetailsVC.coordinator = self
        restaurantDetailsVC.persistenceManager = persistenceManager
        restaurantDetailsVC.delegate = controller
        navigationController.pushViewController(restaurantDetailsVC, animated: true)
    }
}

// MARK: - RestaurantListViewControllerCoordinator
extension RestaurantListCoordinator: RestaurantListViewControllerCoordinator {
    func didSelectRestaurant(_ controller: RestaurantListViewController, restaurant: Restaurant) {
        pushRestaurantDetails(restaurant, controller)
    }
    
    func didTapAddRestaurant(_ controller: RestaurantListViewController) {
        presentCreateRestaurant(from: controller)
    }
}

// MARK: - RestaurantDetailsViewControllerCoordinator
extension RestaurantListCoordinator: RestaurantDetailsViewControllerCoordinator {
    func didTapAddReview(_ controller: RestaurantDetailsViewController, for restaurant: Restaurant) {
        presentCreateReviewScreen(from: controller, for: restaurant)
    }
    
    func didTapEditRestaurant(_ controller: RestaurantDetailsViewController, restaurant: Restaurant) {
        presentEditRestaurant(from: controller, restaurant: restaurant)
    }
}

// MARK: - CreateReviewViewControllerCoordinator
extension RestaurantListCoordinator: CreateReviewViewControllerCoordinator {
    func didFinishCreatingReview(_ controller: CreateReviewViewController, review: Review) {
        controller.dismiss(animated: true)
    }
    
    func didCancelReviewCreation(_ controller: CreateReviewViewController) {
        controller.dismiss(animated: true)
    }
}

// MARK: - EditRestaurantViewControllerCoordinator
extension RestaurantListCoordinator: EditRestaurantViewControllerCoordinator {
    func didFinishEditingRestaurant(_ controller: EditRestaurantViewController) {
        controller.dismiss(animated: true)
    }
}
