//
//  AppCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    func start()
}

// MARK: - AppCoordinator
class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    
    private var authCoordinator: AuthCoordinator?
    private var mainCoordinator: MainCoordinator?

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods
    func start() {
        SessionManager.shared.isAuthenticated ? showMainFlow() : showAuthFlow()
    }

    // MARK: - Private methods
    private func showAuthFlow() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        authCoordinator = coordinator
        mainCoordinator = nil
    }

    private func showMainFlow() {
        let coordinator = MainCoordinator(navigationController: navigationController)
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
extension AppCoordinator: MainCoordinatorDelegate {
    func didRequestLogout(from coordinator: MainCoordinator) {
        showAuthFlow()
    }
}
