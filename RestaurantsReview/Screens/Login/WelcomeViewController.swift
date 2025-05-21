//
//  WelcomeViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import UIKit

// MARK: - WelcomeViewControllerDelegate
protocol WelcomeViewControllerCoordinator: AnyObject {
    func didSelectLogin(_ controller: WelcomeViewController)
    func didSelectRegister(_ controller: WelcomeViewController)
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
    weak var coordinator: WelcomeViewControllerCoordinator?
    var sessionManager: SessionManaging = SessionManager.shared
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        appNameLabel.text = "Restaurants Review"
        appLogoImageView.image = UIImage(named: "appLogo")
        
        #if DEBUG
        setupDebugBarButton()
        #endif
    }
    
    // MARK: - Actions
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        coordinator?.didSelectLogin(self)
    }
    
    @IBAction private func notRegisteredYetButtonTapped(_ sender: UIButton) {
        coordinator?.didSelectRegister(self)
    }
}

#if DEBUG
private extension WelcomeViewController {

    func setupDebugBarButton() {
        let isPopulated = TestDataProvider.isTestingDataAvailable(using: CoreDataManager.shared)
        
        let debugButton = UIBarButtonItem(
            title: isPopulated ? "Clear Test Data" : "Populate Test Data",
            style: .plain,
            target: self,
            action: isPopulated ? #selector(clearTestData) : #selector(populateTestData)
        )

        navigationItem.rightBarButtonItem = debugButton
    }

    @objc func populateTestData() {
        TestDataProvider.populateTestData(using: CoreDataManager.shared)
        print("Populated test data.")
        setupDebugBarButton()
    }

    @objc func clearTestData() {
        TestDataProvider.clearData(using: CoreDataManager.shared)
        print("Cleared all test data.")
        setupDebugBarButton()
    }
}
#endif

// MARK: - RegisterViewControllerDelegate
extension WelcomeViewController: RegisterViewControllerDelegate {
    func didRegisterUser(_ controller: RegisterViewController, didRegister user: User) {
        SessionManager.shared.login(user: user)
    }
}

// MARK: - RegisterViewControllerDelegate
extension WelcomeViewController: LoginViewControllerDelegate {
    func didRegisterUser(_ controller: LoginViewController, didRegister user: User) {
        SessionManager.shared.login(user: user)
    }
}
