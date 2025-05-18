//
//  ProfileCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        
        // TODO: Implement ProfileViewController
        
        let profileVC = AppStoryboard.main.viewController(ofType: ProfileViewController.self)
        navigationController.setViewControllers([profileVC], animated: false)
        profileVC.user = SessionManager.shared.currentUser
//        profileVC.coordinator = self
//        profileVC.delegate = delegate
        navigationController.setViewControllers([profileVC], animated: false)
    }
}
