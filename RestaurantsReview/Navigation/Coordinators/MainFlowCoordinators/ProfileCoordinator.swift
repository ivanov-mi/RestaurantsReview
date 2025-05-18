//
//  ProfileCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let persistenceManager: PersistenceManaging

    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
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
