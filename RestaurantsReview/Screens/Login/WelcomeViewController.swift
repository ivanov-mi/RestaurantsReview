//
//  LoginViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import UIKit

// MARK: - WelcomeViewControllerDelegate
protocol WelcomeViewControllerDelegate: AnyObject {
    func didSelectLogin()
    func didSelectRegister()
}

// MARK: - WelcomeViewController
class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var welcomeToLabel: UILabel!
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var appLogoImageView: UIImageView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var notRegisteredYetButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: WelcomeViewControllerDelegate?

    // MARK: - VC Lifecycle
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
        delegate?.didSelectLogin()
    }

    @IBAction private func notRegisteredYetButtonTapped(_ sender: UIButton) {
        delegate?.didSelectRegister()
    }
}
