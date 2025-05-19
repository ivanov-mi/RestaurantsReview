//
//  AdminCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

class AdminCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let persistenceManager: PersistenceManaging

    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
    }

    func start() {
        let adminVC = AppStoryboard.main.viewController(ofType: AdminViewController.self)
        adminVC.coordinator = self
        navigationController.setViewControllers([adminVC], animated: false)
    }
}


// MARK: - AdminViewControllerCoordinator
extension AdminCoordinator: AdminViewControllerCoordinator {
    func didSelectRestaurants(from controller: AdminViewController) {
        print("Restaurants tapped")
    }
    
    func didSelectUsers(from controller: AdminViewController) {
        let usersVC = AppStoryboard.main.viewController(ofType: UserListingViewController.self)
        usersVC.coordinator = self
        usersVC.persistenceManager = persistenceManager
        navigationController.pushViewController(usersVC, animated: true)
    }
    
    func didSelectReviews(from controller: AdminViewController) {
        let reviewsVC = AppStoryboard.main.viewController(ofType: ReviewsListingViewController.self)
        reviewsVC.coordinator = self
        reviewsVC.persistenceManager = persistenceManager
        navigationController.pushViewController(reviewsVC, animated: true)
    }
}

// MARK: - UserListingViewControllerCoordinator
extension AdminCoordinator: UserListingViewControllerCoordinator {
    func didSelectUser(_ user: User, from controller: UserListingViewController) {
        print("User tapped")
    }
}

// MARK: - ReviewsListingViewControllerCoordinator
extension AdminCoordinator: ReviewsListingViewControllerCoordinator {
    func didSelectReview(_ review: Review, from controller: ReviewsListingViewController) {
        print("Review tapped")
    }
}
