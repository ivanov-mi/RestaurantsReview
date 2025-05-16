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
    var navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods
    func start() {
        let welcomeVC = AppStoryboard.main.viewController(ofType: WelcomeViewController.self)
        welcomeVC.coordinator = self
        navigationController.setViewControllers([welcomeVC], animated: true)
    }

    // MARK: - Private methods
    private func showLogin() {
        let loginVC = AppStoryboard.main.viewController(ofType: LoginViewController.self)
        loginVC.coordinator = self
        navigationController.pushViewController(loginVC, animated: true)
    }

    private func showRegister() {
        let registerVC = AppStoryboard.main.viewController(ofType: RegisterViewController.self)
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    private func finishAuthFlow(with user: User) {
        SessionManager.shared.login(user: user)
        delegate?.authCoordinatorDidFinish(self)
    }
}

// MARK: - WelcomeViewControllerCoordinator
extension AuthCoordinator: WelcomeViewControllerCoordinator {
    func didSelectLogin() {
        showLogin()
    }

    func didSelectRegister() {
        showRegister()
    }
}

// MARK: - LoginViewControllerCoordinator
extension AuthCoordinator: LoginViewControllerCoordinator {
    func didFinishLogin(with user: User) {
        finishAuthFlow(with: user)
    }
}

// MARK: - RegisterViewControllerCoordinator
extension AuthCoordinator: RegisterViewControllerCoordinator {
    func didFinishRegistration(with user: User) {
        finishAuthFlow(with: user)
    }
}
