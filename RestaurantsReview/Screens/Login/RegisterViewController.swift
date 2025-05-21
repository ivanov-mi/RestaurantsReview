//
//  RegisterViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - RegisterScreenMode
enum RegisterScreenMode {
    case create
    case edit(existingUser: User)
}

// MARK: - RegisterViewControllerDelegate
protocol RegisterViewControllerDelegate: AnyObject {
    func didRegisterUser(_ controller: RegisterViewController, user: User)
}

// MARK: - RegisterViewControllerCoordinator
protocol RegisterViewControllerCoordinator: AnyObject {
    func didFinishRegistration(_ controller: RegisterViewController)
}

// MARK: - RegisterViewController
class RegisterViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usernameErrorLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    
    @IBOutlet private weak var passwordFieldStackView: UIStackView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!

    @IBOutlet private var passwordBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var emailErrorBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties
    weak var coordinator: RegisterViewControllerCoordinator?
    weak var delegate: RegisterViewControllerDelegate?
    var persistenceManager: PersistenceManaging!
    
    var mode: RegisterScreenMode = .create

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegates()
        setupSecureFields()
        configureForMode()
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
        handleSubmit()
    }

    // MARK: - Configure Views
    private func setupDelegates() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setupSecureFields() {
        passwordTextField.isSecureTextEntry = true
    }

    private func configureForMode() {
        switch mode {
        case .create:
            setupForCreateMode()
        case .edit(let user):
            setupForEditMode(user: user)
        }
    }
    
    private func setupForCreateMode() {
        title = "Register"
        clearForm()
        passwordFieldStackView.isHidden = false
        passwordBottomConstraint.isActive = true
        emailErrorBottomConstraint.isActive = false
        registerButton.setTitle("Register", for: .normal)
    }

    private func setupForEditMode(user: User) {
        title = "Edit User"
        prepopulateForm(for: user)
        passwordFieldStackView.isHidden = true
        passwordBottomConstraint.isActive = false
        emailErrorBottomConstraint.isActive = true
        registerButton.setTitle("Update", for: .normal)
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
        
        let isPasswordValid: Bool = {
            switch mode {
            case .create:
                return passwordErrorLabel.isHidden && !(passwordTextField.text ?? "").isEmpty
            case .edit:
                return true
            }
        }()
        
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
    
    private func prepopulateForm(for user: User) {
        usernameTextField.text = user.username
        emailTextField.text = user.email
        passwordTextField.text = ""
        
        let errorLabels: [UILabel?] = [usernameErrorLabel, emailErrorLabel, passwordErrorLabel]
        errorLabels.forEach {
            $0?.text = nil
            $0?.isHidden = true
        }

        registerButton.isEnabled = true
    }
    
    private func handleSubmit() {
        guard let username = usernameTextField.text,
              let email = emailTextField.text else { return }

        switch mode {
        case .create:
            handleCreateUser(username: username, email: email)
        case .edit(let existingUser):
            handleEditUser(existingUser: existingUser, username: username, email: email)
        }
    }
    
    private func handleEditUser(existingUser: User, username: String, email: String) {
        let updatedUser = persistenceManager.updateUsernameAndEmail(
            id: existingUser.id,
            username: username,
            email: email
        ) ?? existingUser

        delegate?.didRegisterUser(self, user: updatedUser)
        coordinator?.didFinishRegistration(self)
    }
    
    private func handleCreateUser(username: String, email: String) {
        guard let password = passwordTextField.text else { return }

        #if DEBUG
        let isAdmin = true
        #else
        let isAdmin = false
        #endif

        guard let user = persistenceManager.registerUser(
            username: username,
            email: email,
            password: password,
            isAdmin: isAdmin
        ) else {
            print("Failed to register user.")
            return
        }

        delegate?.didRegisterUser(self, user: user)
        coordinator?.didFinishRegistration(self)
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

