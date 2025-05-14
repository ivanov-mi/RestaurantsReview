//
//  LoginViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import UIKit


class WelcomeViewController: UIViewController {
    
    @IBOutlet weak private var welcomeToLabel: UILabel!
    @IBOutlet weak private var appNameLabel: UILabel!
    @IBOutlet weak private var appLogoImageView: UIImageView!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var notRegistredYetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        appNameLabel.text = "Restaurants Review"
        appLogoImageView.image = UIImage.init(named: "appLogo")
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @IBAction func notRegisteredYetButtonTapped(_ sender: Any) {
        
        // TODO: Implement register user functionality
        
        print("notRegisteredYetButtonTapped")
    }
}
