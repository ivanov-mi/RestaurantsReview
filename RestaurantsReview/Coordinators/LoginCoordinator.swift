//
//  LoginCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func loginCoordinatorDidFinish(_ coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var delegate: LoginCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else {
            fatalError("WelcomeViewController not found in Main storyboard.")
        }
        welcomeVC.delegate = self
        navigationController.setViewControllers([welcomeVC], animated: false)
    }

    private func showLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            fatalError("LoginViewController not found in Main storyboard.")
        }
        loginVC.delegate = self
        navigationController.pushViewController(loginVC, animated: true)
    }

    private func showRegister() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else {
            fatalError("RegisterViewController not found in Main storyboard.")
        }
        registerVC.delegate = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    private func finishLoginFlow(with user: User) {
        delegate?.loginCoordinatorDidFinish(self)
    }
}

extension LoginCoordinator: WelcomeViewControllerDelegate {
    func didSelectLogin() {
        showLogin()
    }

    func didSelectRegister() {
        showRegister()
    }
}


extension LoginCoordinator: LoginViewControllerDelegate {
    func didFinishLogin(with user: User) {
        finishLoginFlow(with: user)
    }
}

extension LoginCoordinator: RegisterViewControllerDelegate {
    func didFinishRegistration(with user: User) {
        finishLoginFlow(with: user)
    }
}
