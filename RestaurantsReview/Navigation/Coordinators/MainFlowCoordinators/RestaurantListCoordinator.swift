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
    
    func showEditRestaurant(from controller: UIViewController, mode: EditRestaurantMode) {
        let editVC = AppStoryboard.main.viewController(ofType: EditRestaurantViewController.self)
        editVC.mode = mode
        editVC.persistenceManager = persistenceManager
        editVC.delegate = self
        let navigationController = UINavigationController(rootViewController: editVC)
        controller.present(navigationController, animated: true)
    }
}

// MARK: - RestaurantListViewControllerCoordinator
extension RestaurantListCoordinator: RestaurantListViewControllerCoordinator {
    func didSelectRestaurant(_ controller: RestaurantListViewController, restaurant: Restaurant) {
        let restaurantDetailsVC = AppStoryboard.main.viewController(ofType: RestaurantDetailsViewController.self)
        restaurantDetailsVC.configure(wtih: restaurant)
        restaurantDetailsVC.coordinator = self
        restaurantDetailsVC.persistenceManager = persistenceManager
        restaurantDetailsVC.delegate = controller
        navigationController.pushViewController(restaurantDetailsVC, animated: true)
    }
    
    func didTapAddRestaurant(_ controller: RestaurantListViewController) {
        showEditRestaurant(from: controller, mode: .create)
    }
}

// MARK: - RestaurantDetailsViewControllerCoordinator
extension RestaurantListCoordinator: RestaurantDetailsViewControllerCoordinator {
    func didTapAddReview(_ controller: RestaurantDetailsViewController, for restaurant: Restaurant) {
        let createReviewVC = AppStoryboard.main.viewController(ofType: CreateReviewViewController.self)
        guard let user = SessionManager.shared.currentUser else {
            
            // TODO: Implement session error flow
            
            return
        }
        
        createReviewVC.configure(with: user.id, for: controller.restaurant.id)
        createReviewVC.coordinator = self
        createReviewVC.persistenceManager = persistenceManager
        createReviewVC.delegate = controller
        
        let navigationController = UINavigationController(rootViewController: createReviewVC)
        controller.present(navigationController, animated: true)
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

// MARK: - EditRestaurantViewControllerDelegate
extension RestaurantListCoordinator: EditRestaurantViewControllerDelegate {
    func didSaveRestaurant(_ restaurant: Restaurant, from controller: EditRestaurantViewController) {
        controller.dismiss(animated: true) {
            if let listVC = self.navigationController.viewControllers.first(where: { $0 is RestaurantListViewController }) as? RestaurantListViewController {
                listVC.reloadRestaurantList()
            }
        }
    }
}
