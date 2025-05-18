//
//  AppCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - AppCoordinator
class AppCoordinator: Coordinator {
    private let persistenceManager: PersistenceManaging
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    private var authCoordinator: AuthCoordinator?
    private var mainCoordinator: MainTabBarCoordinator?

    // MARK: - Init
    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
    }

    // MARK: - Public methods
    func start() {
        SessionManager.shared.isAuthenticated ? showMainFlow() : showAuthFlow()
    }

    // MARK: - Private methods
    private func showAuthFlow() {
        let coordinator = AuthCoordinator(navigationController: navigationController, persistenceManager: persistenceManager)
        coordinator.delegate = self
        coordinator.start()
        authCoordinator = coordinator
        mainCoordinator = nil
    }

    private func showMainFlow() {
        let coordinator = MainTabBarCoordinator(navigationController: navigationController, persistenceManager: persistenceManager)
        coordinator.delegate = self
        coordinator.start()
        mainCoordinator = coordinator
        authCoordinator = nil
    }
}

// MARK: - LoginCoordinatorDelegate
extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        showMainFlow()
    }
}

// MARK: - MainCoordinatorDelegate
extension AppCoordinator: MainTabBarCoordinatorDelegate {
    func didRequestLogout(from coordinator: Coordinator) {
        SessionManager.shared.logout()
        showAuthFlow()
    }
}
