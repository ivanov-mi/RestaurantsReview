//
//  AuthCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - AuthCoordinatorDelegate
protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
}

// MARK: - AuthCoordinator
class AuthCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: AuthCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let persistenceManager: PersistenceManaging

    // MARK: - Init
    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
    }

    // MARK: - Public methods
    func start() {
        let welcomeVC = AppStoryboard.main.viewController(ofType: WelcomeViewController.self)
        welcomeVC.coordinator = self
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.setViewControllers([welcomeVC], animated: true)
    }

    // MARK: - Private methods
    private func showLogin(from controller: WelcomeViewController) {
        let loginVC = AppStoryboard.main.viewController(ofType: LoginViewController.self)
        loginVC.coordinator = self
        loginVC.delegate = controller
        loginVC.persistenceManager = persistenceManager
        navigationController.pushViewController(loginVC, animated: true)
    }

    private func showRegister(from controller: WelcomeViewController) {
        let registerVC = AppStoryboard.main.viewController(ofType: RegisterViewController.self)
        registerVC.coordinator = self
        registerVC.delegate = controller
        registerVC.persistenceManager = persistenceManager
        navigationController.pushViewController(registerVC, animated: true)
    }
}

// MARK: - WelcomeViewControllerCoordinator
extension AuthCoordinator: WelcomeViewControllerCoordinator {
    func didSelectLogin(_ controller: WelcomeViewController) {
        showLogin(from: controller)
    }
    
    func didSelectRegister(_ controller: WelcomeViewController) {
        showRegister(from: controller)
    }
}

// MARK: - LoginViewControllerCoordinator
extension AuthCoordinator: LoginViewControllerCoordinator {
    func didFinishLogin(_ controller: LoginViewController) {
        delegate?.authCoordinatorDidFinish(self)
    }
}

// MARK: - RegisterViewControllerCoordinator
extension AuthCoordinator: RegisterViewControllerCoordinator {
    func didFinishRegistration(_ controller: RegisterViewController) {
        delegate?.authCoordinatorDidFinish(self)
    }
}
