//
//  AppCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController

    private var loginCoordinator: LoginCoordinator?
    private var mainCoordinator: MainCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showLoginFlow()
    }

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

extension AppCoordinator: LoginCoordinatorDelegate {
    func loginCoordinatorDidFinish(_ coordinator: LoginCoordinator) {
        showMainFlow()
    }
}
