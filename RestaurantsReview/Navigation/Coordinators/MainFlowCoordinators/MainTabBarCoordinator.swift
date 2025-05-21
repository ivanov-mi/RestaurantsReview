//
//  MainTabBarCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - MainTabBarCoordinatorDelegate
protocol MainTabBarCoordinatorDelegate: AnyObject {
    func didRequestLogout(from coordinator: Coordinator)
}

// MARK: - MainTabBarCoordinator
class MainTabBarCoordinator: Coordinator {

    // MARK: - Properties
    weak var delegate: MainTabBarCoordinatorDelegate?

    private var navigationController: UINavigationController
    private let tabBarController = MainTabViewController()
    private let persistenceManager: PersistenceManaging

    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
    }

    // MARK: - Coordinator
    func start() {
        let availableTabs = availableTabs()
        let tabItems = setupTabViewControllers(for: availableTabs)

        tabBarController.configureTabs(tabItems)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: true)
    }
    
    // MARK: - Private methods
    private func availableTabs() -> [MainTabItem] {
        var tabs: [MainTabItem] = [.restaurants, .profile]
        if SessionManager.shared.currentUser?.isAdmin ?? false {
            tabs.append(.admin)
        }
        
        return tabs
    }

    private func setupTabViewControllers(for tabs: [MainTabItem]) -> [(MainTabItem, UIViewController)] {
        var tabItems: [(MainTabItem, UIViewController)] = []
        var activeCoordinators: [Coordinator] = []

        for tab in tabs {
            let (coordinator, navigationController) = configureCoordinator(for: tab)
            activeCoordinators.append(coordinator)
            tabItems.append((tab, navigationController))
        }

        childCoordinators.removeAll()
        childCoordinators = activeCoordinators
        return tabItems
    }

    private func configureCoordinator(for tab: MainTabItem) -> (Coordinator, UINavigationController) {
        let navController = UINavigationController()
        let coordinator: Coordinator

        switch tab {
        case .restaurants:
            let restaurantCoordinator = RestaurantListCoordinator(navigationController: navController, persistenceManager: persistenceManager)
            coordinator = restaurantCoordinator

        case .profile:
            let profileCoordinator = ProfileCoordinator(navigationController: navController, persistenceManager: persistenceManager)
            profileCoordinator.delegate = self
            coordinator = profileCoordinator

        case .admin:
            let adminCoordinator = AdminCoordinator(navigationController: navController, persistenceManager: persistenceManager)
            adminCoordinator.delegate = self
            coordinator = adminCoordinator
        }

        coordinator.start()
        return (coordinator, navController)
    }
}

// MARK: - ProfileCoordinatorDelegate
extension MainTabBarCoordinator: ProfileCoordinatorDelegate {
    func didRequestLogout(from coordinator: ProfileCoordinator) {
        delegate?.didRequestLogout(from: self)
    }
    
    func didChangeAdminStatus(from coordinator: ProfileCoordinator) {
        SessionManager.shared.updateCurrentUser()
        start()
    }
}

// MARK: - AdminCoordinatorDelegate
extension MainTabBarCoordinator: AdminCoordinatorDelegate {
    func didRequestLogout(from coordinator: AdminCoordinator) {
        delegate?.didRequestLogout(from: self)
    }
    
    func didChangeAdminStatus(from coordinator: AdminCoordinator) {
        SessionManager.shared.updateCurrentUser()
        start()
    }
}
    
