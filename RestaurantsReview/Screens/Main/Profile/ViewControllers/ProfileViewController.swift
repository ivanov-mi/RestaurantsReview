//
//  ProfileViewController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - ProfileViewControllerCoordinator
protocol ProfileViewControllerCoordinator: AnyObject {
    func didRequestLogout(from controller: ProfileViewController)
    func didChangeAdminStatus(from controller: ProfileViewController)
}


// MARK: - ProfileViewController
class ProfileViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: ProfileViewControllerCoordinator?
    var persistenceManager: PersistenceManaging!
    var user: User!

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var deleteProfileButton: UIButton!
    @IBOutlet weak private var deleteBackgroundView: UIView!

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"

        setupTableView()
        deleteBackgroundView.backgroundColor = tableView.backgroundColor
    }

    // MARK: - Setup
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
    
    // MARK: - Private functions
    private func logoutTapped() {
        coordinator?.didRequestLogout(from: self)
    }
    
    private func presentDeleteConfirmationAlert() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self else { return }
            
            persistenceManager.deleteUser(userId: user.id)
            coordinator?.didRequestLogout(from: self)
        })
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        ProfileSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = ProfileSection(rawValue: section) else { return 0 }
        return section.rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ProfileSection(rawValue: indexPath.section) else { return UITableViewCell() }
        let row = section.rows[indexPath.row]

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
        let row = section.rows[indexPath.row]

        guard row.isTappable else { return }

        switch row {
        case .logout:
            logoutTapped()
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ProfileSwitchTableViewCellDelegate
extension ProfileViewController: ProfileSwitchTableViewCellDelegate {
    func profileSwitchCell(_ cell: ProfileSwitchTableViewCell, didChangeValue isOn: Bool) {
        guard let updatedUser = persistenceManager.changeAdminStatus(for: user.id, to: isOn) else {
            return
        }
        
        self.user = updatedUser
        tableView.reloadData()
        coordinator?.didChangeAdminStatus(from: self)
    }
}

// MARK: - ProfileSection
enum ProfileSection: Int, CaseIterable {
    case account
    case admin
    case actions

    var rows: [ProfileRow] {
        switch self {
        case .account: return [.username, .email]
        case .admin:   return [.adminToggle]
        case .actions: return [.logout]
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
        case .logout: return true
        default: return false
        }
    }

    var title: String {
        switch self {
        case .username: return "Username"
        case .email: return "Email"
        case .adminToggle: return "Admin Role"
        case .logout: return "Logout"
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
