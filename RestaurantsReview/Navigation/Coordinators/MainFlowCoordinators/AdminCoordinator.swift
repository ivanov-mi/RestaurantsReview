//
//  AdminCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

class AdminCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        
        // TODO: Implement AdminViewController
        
        let adminVC = AppStoryboard.main.viewController(ofType: AdminViewController.self)
        navigationController.setViewControllers([adminVC], animated: false)
    }
}
