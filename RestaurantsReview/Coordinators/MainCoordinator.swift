//
//  MainCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let listVC = storyboard.instantiateViewController(withIdentifier: "RestaurantListViewController") as? RestaurantListViewController else {
            fatalError("RestaurantListViewController not found.")
        }

        listVC.coordinator = self
        navigationController.setViewControllers([listVC], animated: false)
    }
}

extension MainCoordinator: RestaurantListViewControllerCoordinator {
    func didSelectRestaurant(_ controller: RestaurantListViewController, restaurant: Restaurant) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailsViewController") as? RestaurantDetailsViewController else {
            fatalError("RestaurantDetailsViewController not found.")
        }

        detailsVC.restaurant = restaurant
        detailsVC.coordinator = self
        detailsVC.delegate = controller
        navigationController.pushViewController(detailsVC, animated: true)
    }
}

extension MainCoordinator: RestaurantDetailsViewControllerCoordinator {
    func didTapAddReview(_ controller: RestaurantDetailsViewController, for restaurant: Restaurant) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let createReviewVC = storyboard.instantiateViewController(withIdentifier: "CreateReviewViewController") as? CreateReviewViewController else {
            fatalError("CreateReviewViewController not found.")
        }

        // TODO: Fix user identity
        
        createReviewVC.userId = UUID()
        createReviewVC.coordinator = self
        createReviewVC.delegate = controller
        navigationController.pushViewController(createReviewVC, animated: true)
    }
}

extension MainCoordinator: CreateReviewViewControllerCoordinator {
    func didFinishCreatingReview(_ controller: CreateReviewViewController, review: Review) {
        navigationController.popViewController(animated: true)
    }

    func didCancelReviewCreation(_ controller: CreateReviewViewController) {
        navigationController.popViewController(animated: true)
    }
}
