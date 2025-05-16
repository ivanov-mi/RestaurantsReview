//
//  LoginViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import UIKit

protocol WelcomeViewControllerDelegate: AnyObject {
    func didSelectLogin()
    func didSelectRegister()
}

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var welcomeToLabel: UILabel!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var appLogoImageView: UIImageView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var notRegisteredYetButton: UIButton!
    
    weak var delegate: WelcomeViewControllerDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI Setup
    private func configureUI() {
        appNameLabel.text = "Restaurants Review"
        appLogoImageView.image = UIImage(named: "appLogo")
    }

    // MARK: - Actions
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        navigateToLogin()
    }

    @IBAction private func notRegisteredYetButtonTapped(_ sender: UIButton) {
        
        delegate?.didSelectRegister()
        
    }

    // MARK: - Navigation
    private func navigateToLogin() {
        
        delegate?.didSelectLogin()
    }
}
