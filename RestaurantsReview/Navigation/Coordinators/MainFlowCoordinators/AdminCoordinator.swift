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
        
        // TODO: Implement AdminViewController
        
        let adminVC = AppStoryboard.main.viewController(ofType: AdminViewController.self)
        navigationController.setViewControllers([adminVC], animated: false)
    }
}
