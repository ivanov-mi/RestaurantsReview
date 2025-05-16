//
//  MainCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - MainCoordinatorDelegate
protocol MainCoordinatorDelegate: AnyObject {
    func didRequestLogout(from coordinator: MainCoordinator)
}

// MARK: - MainCoordinator
class MainCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: MainCoordinatorDelegate?
    var navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods
    func start() {
        let restaurantListVC = AppStoryboard.main.viewController(ofType: RestaurantListViewController.self)
        restaurantListVC.coordinator = self
        navigationController.setViewControllers([restaurantListVC], animated: true)
    }
}

// MARK: - RestaurantListViewControllerCoordinator
extension MainCoordinator: RestaurantListViewControllerCoordinator {
    func didSelectRestaurant(_ source: RestaurantListViewController, restaurant: Restaurant) {
        let restaurantDetailsVC = AppStoryboard.main.viewController(ofType: RestaurantDetailsViewController.self)
        restaurantDetailsVC.restaurant = restaurant
        restaurantDetailsVC.coordinator = self
        restaurantDetailsVC.delegate = source
        navigationController.pushViewController(restaurantDetailsVC, animated: true)
    }
    
    func didTapLogout(_ controller: RestaurantListViewController) {
        SessionManager.shared.logout()
        delegate?.didRequestLogout(from: self)
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
