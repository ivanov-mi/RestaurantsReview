//
//  RestaurantListCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - RestaurantListCoordinatorDelegate
protocol RestaurantListCoordinatorDelegate: AnyObject {
    func didRequestLogout(from coordinator: RestaurantListCoordinator)
}

// MARK: - RestaurantListCoordinator
class RestaurantListCoordinator: Coordinator {

    // MARK: - Properties
    weak var delegate: RestaurantListCoordinatorDelegate?
    var navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator
    func start() {
        let listVC = AppStoryboard.main.viewController(ofType: RestaurantListViewController.self)
        listVC.coordinator = self
        navigationController.setViewControllers([listVC], animated: false)
    }
}

// MARK: - RestaurantListViewControllerCoordinator
extension RestaurantListCoordinator: RestaurantListViewControllerCoordinator {
    func didTapLogout(_ controller: RestaurantListViewController) {
        delegate?.didRequestLogout(from: self)
    }

    func didSelectRestaurant(_ controller: RestaurantListViewController, restaurant: Restaurant) {
        let restaurantDetailsVC = AppStoryboard.main.viewController(ofType: RestaurantDetailsViewController.self)
        restaurantDetailsVC.coordinator = self
        restaurantDetailsVC.restaurant = restaurant
        restaurantDetailsVC.delegate = controller
        navigationController.pushViewController(restaurantDetailsVC, animated: true)
    }
}

// MARK: - RestaurantDetailsViewControllerCoordinator
extension RestaurantListCoordinator: RestaurantDetailsViewControllerCoordinator {
    func didTapAddReview(_ controller: RestaurantDetailsViewController, for restaurant: Restaurant) {
        let createReviewVC = AppStoryboard.main.viewController(ofType: CreateReviewViewController.self)
        
        // TODO: Fix user identity

        createReviewVC.userId = UUID()
        createReviewVC.coordinator = self
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
