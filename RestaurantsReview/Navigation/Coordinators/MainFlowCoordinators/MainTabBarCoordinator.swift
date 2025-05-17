//
//  MainTabBarCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/15/25.
//

import UIKit

// MARK: - MainTabBarCoordinatorDelegate
protocol MainTabBarCoordinatorDelegate: AnyObject {
    func didRequestLogout(from coordinator: MainTabBarCoordinator)
}

// MARK: - MainTabBarCoordinator
class MainTabBarCoordinator: Coordinator {

    // MARK: - Properties
    weak var delegate: MainTabBarCoordinatorDelegate?
    
    private(set) var navigationController: UINavigationController
    let tabBarController = UITabBarController()

    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Coordinator
    func start() {
        setupTabs()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setViewControllers([tabBarController], animated: true)
    }

    // MARK: - Private Methods
    private func setupTabs() {
        var tabs: [UIViewController] = []
        var coordinators: [Coordinator] = []
        
        let restaurantNav = UINavigationController()
        let restaurantCoordinator = RestaurantListCoordinator(navigationController: restaurantNav)
        restaurantCoordinator.delegate = self
        restaurantCoordinator.start()
        restaurantNav.tabBarItem = UITabBarItem(title: "Restaurants", image: UIImage(systemName: "fork.knife"), tag: 0)
        tabs.append(restaurantNav)
        coordinators.append(restaurantCoordinator)
        
        let profileNav = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNav)
        profileCoordinator.start()
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        tabs.append(profileNav)
        coordinators.append(profileCoordinator)
        
        if let user = SessionManager.shared.currentUser, user.role == .admin {
            let adminNav = UINavigationController()
            let adminCoordinator = AdminCoordinator(navigationController: adminNav)
            adminCoordinator.start()
            adminNav.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "gearshape"), tag: 2)
            tabs.append(adminNav)
            coordinators.append(adminCoordinator)
        }
        
        tabBarController.viewControllers = tabs
        childCoordinators = coordinators
    }
}

// MARK: - RestaurantListCoordinatorDelegate
extension MainTabBarCoordinator: RestaurantListCoordinatorDelegate {
    func didRequestLogout(from coordinator: RestaurantListCoordinator) {
        delegate?.didRequestLogout(from: self)
    }
}

