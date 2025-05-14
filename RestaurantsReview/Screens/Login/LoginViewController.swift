//
//  Untitled.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    // TODO: Remove after implementing local persistance
    let testUser = TestDataProvider.shared.testUser
    
    @IBOutlet weak private var scrollView: UIScrollView!
    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var emailErrorLabel: UILabel!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var passwordErrorLabel: UILabel!
    
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        
        loginButton.setTitle("Login", for: .normal)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        clearInputForm()
        setupKeyboardHandling()
    }
    
    
    @IBAction func emailTextFieldEditingChanged(_ sender: Any) {
        if let email = self.emailTextField.text {
            if let errorMessage = invalidEmail(email) {
                emailErrorLabel.text = errorMessage
                emailErrorLabel.isHidden = false
            } else {
                emailErrorLabel.isHidden = true
            }
        }
        
        setSignInButton()
    }

    @IBAction func passwordTextFieldEditingChanged(_ sender: Any) {
        if let password = self.passwordTextField.text {
            if let errorMessage = invalidPassword(password) {
                passwordErrorLabel.text = errorMessage
                passwordErrorLabel.isHidden = false
            } else {
                passwordErrorLabel.isHidden = true
            }
        }
        
        setSignInButton()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        checkUsernameAndPassword()
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        
        // TODO: Implement forgot password functionality
        
        #if DEBUG
        emailTextField.text = testUser.email
        passwordTextField.text = testUser.password

        emailTextFieldEditingChanged(emailTextField as Any)
        passwordTextFieldEditingChanged(passwordTextField as Any)
        #endif
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

private extension LoginViewController {
    func checkUsernameAndPassword() {
        
        // TODO: Implement identity check
        
        if emailTextField.text == testUser.email && passwordTextField.text == testUser.password {
            goToMainApp()
            clearInputForm()
        } else {
            setInputFormWhenWrongPasswordOrUsername()
        }
    }
    
    func goToMainApp() {        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "RestaurantListViewController")
        let navController = UINavigationController(rootViewController: mainVC)

        // Replace the root view controller
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = navController
            window.applyPushTransition()
            window.makeKeyAndVisible()
        }
    }
    
    func setSignInButton() {
        if emailErrorLabel.isHidden,
           emailTextField.text != "",
           passwordErrorLabel.isHidden,
           passwordTextField.text != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    func clearInputForm() {
        loginButton.isEnabled = false
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        setEmailTextField()
        setPasswordTextField()
    }
    
    func setInputFormWhenWrongPasswordOrUsername() {
        loginButton.isEnabled = false
        passwordErrorLabel.isHidden = false
        passwordErrorLabel.text = Errors.invalidUsernameOrPassword
        
        setPasswordTextField()
    }
    
    func setEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.text = ""
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress
    }
    
    func setPasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.text = ""
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
    }
    
    func invalidPassword(_ text: String) -> String? {
        if text.count < Constants.passwordMinLength {
            return Errors.passwordLength
        }
        if containsDigit(text) {
            return Errors.mustContainDigit
        }
        if containsAlphabetCharacter(text) {
            return Errors.mustContainAplabetChar
        }
        
        return nil
    }
    
    func containsDigit(_ text: String) -> Bool {
        let regex = Regexes.digit
        let predicate = NSPredicate(format: Constants.regexPredicateFormat, regex)
        return !predicate.evaluate(with: text)
    }
    
    func containsAlphabetCharacter(_ text: String) -> Bool {
        let regex = Regexes.alphabetCharacter
        let predicate = NSPredicate(format: Constants.regexPredicateFormat, regex)
        return !predicate.evaluate(with: text)
    }
    
    func invalidEmail(_ text: String) -> String? {
        let regex = Regexes.email
        let predicate = NSPredicate(format: Constants.regexPredicateFormat, regex)
        if !predicate.evaluate(with: text) {
            return Errors.invalidEmail
        }
        
        return nil
    }
}

private extension LoginViewController {
    enum Constants {
        static let passwordMinLength = 8
        static let regexPredicateFormat = "SELF MATCHES %@"
    }
    
    enum Errors {
        static let invalidUsernameOrPassword = "Invalid Username or Password"
        static let passwordLength = "Password must be at leat 8 symbols"
        static let mustContainDigit = "Password must contain at least 1 digit."
        static let mustContainAplabetChar = "Password must contant at leat 1 aplhabet character"
        static let invalidEmail = "Invalid Email Address"
    }
    
    enum Regexes {
        static let digit = ".*[0-9].*"
        static let alphabetCharacter = ".*[A-Za-z].*"
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
}
