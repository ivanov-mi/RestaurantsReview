//
//  RegisterViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usernameErrorLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        clearForm()
    }

    // MARK: - Actions
    @IBAction private func usernameEditingChanged(_ sender: UITextField) {
        validateField(textField: sender, label: usernameErrorLabel, validator: invalidUsername)
    }

    @IBAction private func emailEditingChanged(_ sender: UITextField) {
        validateField(textField: sender, label: emailErrorLabel, validator: invalidEmail)
    }

    @IBAction private func passwordEditingChanged(_ sender: UITextField) {
        validateField(textField: sender, label: passwordErrorLabel, validator: invalidPassword)
    }

    @IBAction private func registerButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        let user = User(name: username, email: email, password: password)

        // TODO: Implement create user functionality
        print("User registered: \(user)")
    }

    // MARK: - Validation Logic
    private func validateField(textField: UITextField, label: UILabel, validator: (String) -> String?) {
        let text = textField.text ?? ""
        label.text = validator(text)
        label.isHidden = label.text == nil
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

    // MARK: - Validation Rules
    private func invalidUsername(_ username: String) -> String? {
        let regex = "^[A-Za-z0-9._]{3,}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: username)
        return isValid ? nil : "Username can contain only letters, numbers, dots, or underscores"
    }

    private func invalidEmail(_ email: String) -> String? {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
        return isValid ? nil : "Invalid Email"
    }

    private func invalidPassword(_ password: String) -> String? {
        if password.count < 8 {
            return "Password must be at least 8 characters"
        }
        if !password.contains(where: \.isNumber) {
            return "Password must contain at least one digit"
        }
        if !password.contains(where: \.isLetter) {
            return "Password must contain at least one letter"
        }
        return nil
    }
}

