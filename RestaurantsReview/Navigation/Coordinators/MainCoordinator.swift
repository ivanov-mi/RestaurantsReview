//
//  MainCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods
    func start() {
        let restaurantListVC = AppStoryboard.main.viewController(ofType: RestaurantListViewController.self)
        restaurantListVC.coordinator = self
        navigationController.setViewControllers([restaurantListVC], animated: false)
    }
}

// MARK: - RestaurantListViewControllerCoordinato
extension MainCoordinator: RestaurantListViewControllerCoordinator {
    func didSelectRestaurant(_ source: RestaurantListViewController, restaurant: Restaurant) {
        let restaurantDetailsVC = AppStoryboard.main.viewController(ofType: RestaurantDetailsViewController.self)
        restaurantDetailsVC.restaurant = restaurant
        restaurantDetailsVC.coordinator = self
        restaurantDetailsVC.delegate = source
        navigationController.pushViewController(restaurantDetailsVC, animated: true)
    }
}

// MARK: - RestaurantDetailsViewControllerCoordinator
extension MainCoordinator: RestaurantDetailsViewControllerCoordinator {
    func didTapAddReview(_ source: RestaurantDetailsViewController, for restaurant: Restaurant) {
        let createReviewVC = AppStoryboard.main.viewController(ofType: CreateReviewViewController.self)

        // TODO: Fix user identity
        
        createReviewVC.userId = UUID()
        createReviewVC.coordinator = self
        createReviewVC.delegate = source
        navigationController.pushViewController(createReviewVC, animated: true)
    }
}

// MARK: - CreateReviewViewControllerCoordinator
extension MainCoordinator: CreateReviewViewControllerCoordinator {
    func didFinishCreatingReview(_ source: CreateReviewViewController, review: Review) {
        navigationController.popViewController(animated: true)
    }

    func didCancelReviewCreation(_ source: CreateReviewViewController) {
        navigationController.popViewController(animated: true)
    }
}
