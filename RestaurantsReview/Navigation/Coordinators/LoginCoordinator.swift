//
//  LoginCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - LoginCoordinatorDelegate
protocol LoginCoordinatorDelegate: AnyObject {
    func loginCoordinatorDidFinish(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator {
    
    // MARK: - Properties
    weak var delegate: LoginCoordinatorDelegate?
    var navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods
    func start() {
        let welcomeVC = AppStoryboard.main.viewController(ofType: WelcomeViewController.self)
        welcomeVC.delegate = self
        navigationController.setViewControllers([welcomeVC], animated: false)
    }

    // MARK: - Private methods
    private func showLogin() {
        let loginVC = AppStoryboard.main.viewController(ofType: LoginViewController.self)
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }

    private func showRegister() {
        let registerVC = AppStoryboard.main.viewController(ofType: RegisterViewController.self)
        registerVC.delegate = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    private func finishLoginFlow(with user: User) {
        delegate?.loginCoordinatorDidFinish(self)
    }
}

// MARK: - WelcomeViewControllerDelegate
extension LoginCoordinator: WelcomeViewControllerDelegate {
    func didSelectLogin() {
        showLogin()
    }

    func didSelectRegister() {
        showRegister()
    }
}

// MARK: - LoginViewControllerDelegate
extension LoginCoordinator: LoginViewControllerDelegate {
    func didFinishLogin(with user: User) {
        finishLoginFlow(with: user)
    }
}

// MARK: - RegisterViewControllerDelegate
extension LoginCoordinator: RegisterViewControllerDelegate {
    func didFinishRegistration(with user: User) {
        finishLoginFlow(with: user)
    }
}
