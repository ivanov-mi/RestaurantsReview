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

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    var navigationController: UINavigationController
    
    private var loginCoordinator: LoginCoordinator?
    private var mainCoordinator: MainCoordinator?

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods
    func start() {
        showLoginFlow()
    }

    // MARK: - Private methods
    private func showLoginFlow() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        loginCoordinator = coordinator
        mainCoordinator = nil
    }

    private func showMainFlow() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
        mainCoordinator = coordinator
        loginCoordinator = nil
    }
}

// MARK: - LoginCoordinatorDelegate
extension AppCoordinator: LoginCoordinatorDelegate {
    func loginCoordinatorDidFinish(_ coordinator: LoginCoordinator) {
        showMainFlow()
    }
}
