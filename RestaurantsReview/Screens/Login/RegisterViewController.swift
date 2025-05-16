//
//  RegisterViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - RegisterViewControllerDelegate
protocol RegisterViewControllerCoordinator: AnyObject {
    func didFinishRegistration(with user: User)
}


// MARK: - RegisterViewController
class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usernameErrorLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!
    
    // MARK: - Properties
    weak var coordinator: RegisterViewControllerCoordinator?

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupDelegates()
        setupSecureFields()
        clearForm()
    }

    // MARK: - Actions
    @IBAction private func usernameEditingChanged(_ sender: UITextField) {
        updateFieldValidationState(textField: sender, errorLabel: usernameErrorLabel, validation: AuthInputValidator.validateUsername)
    }

    @IBAction private func emailEditingChanged(_ sender: UITextField) {
        updateFieldValidationState(textField: sender, errorLabel: emailErrorLabel, validation: AuthInputValidator.validateEmail)
    }

    @IBAction private func passwordEditingChanged(_ sender: UITextField) {
        updateFieldValidationState(textField: sender, errorLabel: passwordErrorLabel, validation: AuthInputValidator.validatePasswordCreation)
    }
    
    @IBAction private func registerButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        // TODO: Implement create user functionality
        
        let user = User(name: username, email: email, password: password)
        coordinator?.didFinishRegistration(with: user)
    }
    
    // MARK: - Configure Views
    private func setupNavigation() {
        title = "Register"
    }

    private func setupDelegates() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setupSecureFields() {
        passwordTextField.isSecureTextEntry = true
    }

    // MARK: - Validation Logic
    private func updateFieldValidationState(textField: UITextField, errorLabel: UILabel, validation: (String) -> AuthInputValidatorResult) {
        let text = textField.text ?? ""
        let result = validation(text)
        errorLabel.text = result.error?.errorDescription
        errorLabel.isHidden = result.isValid
        updateRegisterButtonState()
    }

    private func updateRegisterButtonState() {
        let isUsernameValid = usernameErrorLabel.isHidden && !(usernameTextField.text ?? "").isEmpty
        let isEmailValid = emailErrorLabel.isHidden && !(emailTextField.text ?? "").isEmpty
        let isPasswordValid = passwordErrorLabel.isHidden && !(passwordTextField.text ?? "").isEmpty

        registerButton.isEnabled = isUsernameValid && isEmailValid && isPasswordValid
    }

    private func clearForm() {
        let textFields: [UITextField?] = [usernameTextField, emailTextField, passwordTextField]
        textFields.forEach { $0?.text = "" }
        
        let errorLabels: [UILabel?] = [usernameErrorLabel, emailErrorLabel, passwordErrorLabel]
        errorLabels.forEach {
            $0?.text = nil
            $0?.isHidden = true
        }

        registerButton.isEnabled = false
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

