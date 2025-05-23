//
//  ProfileViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - ProfileViewControllerDelegate
protocol ProfileViewControllerDelegate: AnyObject {
    func didUpdateUser(_ controller: ProfileViewController)
}

// MARK: - ProfileViewControllerCoordinator
protocol ProfileViewControllerCoordinator: AnyObject {
    func didRequestLogout(from controller: ProfileViewController)
    func didDeleteUser(from controller: ProfileViewController)
    func didRemoveCurrentUserAdminStatus(from controller: ProfileViewController)
    func didRequestEditUser(from controller: ProfileViewController, user: User)
}

// MARK: - ProfileViewController
class ProfileViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: ProfileViewControllerCoordinator?
    weak var delegate: ProfileViewControllerDelegate?
    
    var persistenceManager: PersistenceManaging!
    var sessionManager: SessionManaging = SessionManager.shared
    var user: User!
    
    private var showsLogout: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var deleteProfileButton: UIButton!
    @IBOutlet weak private var deleteBackgroundView: UIView!

    // MARK: - VCLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        
        configureViewPermissions()
        setupTableView()
        deleteBackgroundView.backgroundColor = tableView.backgroundColor
        deleteBackgroundView.isHidden = false
    }

    // MARK: - Setup
    private func configureViewPermissions() {
        guard let currentUser = sessionManager.currentUser else { return }
        showsLogout = currentUser.id == user.id
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(ProfileDetailsTableViewCell.nib, forCellReuseIdentifier: ProfileDetailsTableViewCell.identifier)
        tableView.register(ProfileSwitchTableViewCell.nib, forCellReuseIdentifier: ProfileSwitchTableViewCell.identifier)
        tableView.register(ProfileLogoutTableViewCell.nib, forCellReuseIdentifier: ProfileLogoutTableViewCell.identifier)
    }

    // MARK: - Actions
    @IBAction private func deleteTapped(_ sender: Any) {
        presentDeleteConfirmationAlert()
    }
    
    private func logoutTapped() {
        coordinator?.didRequestLogout(from: self)
    }
    
    private func presentDeleteConfirmationAlert() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete this account? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            
            persistenceManager.deleteUser(userId: user.id)
            if user.id == sessionManager.currentUser?.id {
                sessionManager.logout()
            }
            
            delegate?.didUpdateUser(self)
            coordinator?.didDeleteUser(from: self)
        })
        present(alert, animated: true)
    }
    
    private func presentAdminStatusChangeConfirmationAlert(for user: User, switchCell: ProfileSwitchTableViewCell) {
        let isOn = switchCell.isOn
        let alert = UIAlertController(
            title: isOn ? "Grant Admin Status" : "Remove Admin Status",
            message: isOn
                ? "Are you sure you want to give this user admin privileges?"
                : "Are you sure you want to remove this user's admin privileges?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            switchCell.toggle()
        })

        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive) { [weak self] _ in
            self?.updateAdminStatus(for: user, to: isOn)
        })

        present(alert, animated: true)
    }
    
    private func updateAdminStatus(for user: User, to isOn: Bool) {
        guard let updatedUser = persistenceManager.changeAdminStatus(for: user.id, to: isOn) else {
            return
        }
        
        self.user = updatedUser
        tableView.reloadData()
        delegate?.didUpdateUser(self)
        
        if sessionManager.currentUser?.id == user.id {
            coordinator?.didRemoveCurrentUserAdminStatus(from: self)
        }
    }
    
    private func rows(for section: ProfileSection) -> [ProfileRow] {
        section.rows(showsLogout: showsLogout)
    }
    
    private func editUserDetails() {
        coordinator?.didRequestEditUser(from: self, user: user)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        ProfileSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = ProfileSection(rawValue: section) else { return 0 }
        return rows(for: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ProfileSection(rawValue: indexPath.section) else { return UITableViewCell() }
        let rows = rows(for: section)
        let row = rows[indexPath.row]
        
        switch row {
        case .username, .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath) as! ProfileDetailsTableViewCell
            let value = row == .username ? user.username : user.email
            cell.configure(title: row.title, value: value)
            cell.selectionStyle = .none
            return cell

        case .adminToggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath) as! ProfileSwitchTableViewCell
            cell.configure(title: row.title, isOn: user.isAdmin)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell

        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath) as! ProfileLogoutTableViewCell
            cell.configure(title: row.title)
            cell.selectionStyle = row.isTappable ? .default : .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = ProfileSection(rawValue: indexPath.section) else { return }
        let rows = rows(for: section)
        let row = rows[indexPath.row]
        
        guard row.isTappable else { return }

        switch row {
        case .logout:
            logoutTapped()
        case .username, .email:
            editUserDetails()
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ProfileSwitchTableViewCellDelegate
extension ProfileViewController: ProfileSwitchTableViewCellDelegate {
    func profileSwitchCell(_ cell: ProfileSwitchTableViewCell, didChangeValue isOn: Bool) {
        guard !user.isAdmin else {
            presentAdminStatusChangeConfirmationAlert(for: user, switchCell: cell)
            return
        }
        
        updateAdminStatus(for: user, to: isOn)
    }
}

extension ProfileViewController: RegisterViewControllerDelegate {
    func didRegisterUser(_ controller: RegisterViewController, user: User) {
        controller.dismiss(animated: true)

        self.user = user
        tableView.reloadData()
        delegate?.didUpdateUser(self)
    }
}

// MARK: - ProfileSection
enum ProfileSection: Int, CaseIterable {
    case account
    case admin
    case actions
    
    func rows(showsLogout: Bool) -> [ProfileRow] {
        switch self {
        case .account:
            return [.username, .email]
        case .admin:
            return [.adminToggle]
        case .actions:
            return showsLogout ? [.logout] : []
        }
    }
}

// MARK: - ProfileRow
enum ProfileRow {
    case username
    case email
    case adminToggle
    case logout

    var isTappable: Bool {
        switch self {
        case .username, .email, .logout:
            return true
        default:
            return false
        }
    }

    var title: String {
        switch self {
        case .username:
            return "Username"
        case .email:
            return "Email"
        case .adminToggle:
            return "Admin Role"
        case .logout:
            return "Logout"
        }
    }

    var cellIdentifier: String {
        switch self {
        case .username, .email:
            return ProfileDetailsTableViewCell.identifier
        case .adminToggle:
            return ProfileSwitchTableViewCell.identifier
        case .logout:
            return ProfileLogoutTableViewCell.identifier
        }
    }
}
