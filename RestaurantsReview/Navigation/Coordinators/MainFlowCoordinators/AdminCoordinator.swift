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
        print("Users tapped")
    }
    
    func didSelectReviews(from controller: AdminViewController) {
        print("Reviews tapped")
    }
}
