//
//  ProfileCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - ProfileCoordinatorDelegate
protocol ProfileCoordinatorDelegate: AnyObject {
    func didRequestLogout(from coordinator: ProfileCoordinator)
    func didChangeAdminStatus(from coordinator: ProfileCoordinator)
}
 
// MARK: - ProfileCoordinator
class ProfileCoordinator: Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    private let persistenceManager: PersistenceManaging
    weak var delegate: ProfileCoordinatorDelegate?

    // MARK: - Init
    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
    }

    // MARK: - Public methods
    func start() {
        let profileVC = AppStoryboard.main.viewController(ofType: ProfileViewController.self)
        navigationController.setViewControllers([profileVC], animated: false)
        profileVC.user = SessionManager.shared.currentUser
        profileVC.coordinator = self
        profileVC.persistenceManager = persistenceManager
        navigationController.setViewControllers([profileVC], animated: false)
    }
}


// MARK: - ProfileViewControllerCoordinator
extension ProfileCoordinator: ProfileViewControllerCoordinator {
    func didRequestLogout(from controller: ProfileViewController) {
        delegate?.didRequestLogout(from: self)
    }
    
    func didRemoveCurrentUserAdminStatus(from controller: ProfileViewController) {
        delegate?.didChangeAdminStatus(from: self)
    }
}
