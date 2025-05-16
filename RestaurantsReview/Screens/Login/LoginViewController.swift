//
//  LoginViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import UIKit

// MARK: - LoginViewControllerDelegate
protocol LoginViewControllerCoordinator: AnyObject {
    func didFinishLogin(with user: User)
}

// MARK - LoginViewController
class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var emailErrorLabel: UILabel!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var passwordErrorLabel: UILabel!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var forgotPasswordButton: UIButton!
    
    // MARK: - Properties
    weak var coordinator: LoginViewControllerCoordinator?
    
    // TODO: Remove after implementing local peristence
    #if DEBUG
    let testUser = TestDataProvider.shared.testUser
    #endif

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupKeyboardHandling()
        setupUI()
        clearForm()
    }

    // MARK: - Actions
    @IBAction private func emailEditingChanged(_ sender: UITextField) {
        updateFieldValidationState(textField: sender, errorLabel: emailErrorLabel, validation: AuthInputValidator.validateEmail)
    }

    @IBAction private func passwordEditingChanged(_ sender: UITextField) {
        updateFieldValidationState(textField: sender, errorLabel: passwordErrorLabel, validation: AuthInputValidator.validateLoginPassword)
    }

    @IBAction private func loginButtonTapped(_ sender: Any) {
        authenticate()
    }

    @IBAction private func forgotPasswordButtonTapped(_ sender: Any) {
        
        // TODO: Implement forgot password functionality
        
        #if DEBUG
        emailTextField.text = testUser.email
        passwordTextField.text = testUser.password
        emailEditingChanged(emailTextField)
        passwordEditingChanged(passwordTextField)
        updateLoginButtonState()
        #endif
    }

    // MARK: - Configure Views
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupUI() {
        title = "Login"
        loginButton.setTitle("Login", for: .normal)
        forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        passwordTextField.isSecureTextEntry = true
    }
    
    private func clearForm() {
        emailTextField.text = ""
        emailTextField.placeholder = "Email"
        emailTextField.textContentType = .username
        emailTextField.keyboardType = .emailAddress

        passwordTextField.text = ""
        passwordTextField.placeholder = "Password"
        passwordTextField.textContentType = .password

        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        loginButton.isEnabled = false
    }
    
    // MARK: - Validation Handling
    private func updateFieldValidationState(textField: UITextField, errorLabel: UILabel, validation: (String) -> AuthInputValidatorResult) {
        let result = validation(textField.text ?? "")
        errorLabel.text = result.error?.errorDescription
        errorLabel.isHidden = result.isValid
        updateLoginButtonState()
    }

    private func updateLoginButtonState() {
        let isEmailValid = emailErrorLabel.isHidden && !(emailTextField.text ?? "").isEmpty
        let isPasswordValid = passwordErrorLabel.isHidden && !(passwordTextField.text ?? "").isEmpty
        loginButton.isEnabled = isEmailValid && isPasswordValid
    }

    private func showInvalidCredentialsError() {
        passwordErrorLabel.text = "Invalid Username or Password"
        passwordErrorLabel.isHidden = false
        passwordTextField.text = ""
        updateLoginButtonState()
    }

    // MARK: - Authentication
    private func authenticate() {
        
        // TODO: Implement authentication
        
        #if DEBUG
        guard emailTextField.text == testUser.email,
              passwordTextField.text == testUser.password else {
            showInvalidCredentialsError()
            return
        }

        coordinator?.didFinishLogin(with: testUser)
        clearForm()
        #endif

    }

    // MARK: - Handle keyboard
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset.bottom = frame.height
            scrollView.verticalScrollIndicatorInsets.bottom = frame.height
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
