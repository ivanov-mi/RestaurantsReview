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
    
    var navigationController: UINavigationController
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
        let restaurantNav = UINavigationController()
        let restaurantCoordinator = RestaurantListCoordinator(navigationController: restaurantNav)
        restaurantCoordinator.delegate = self
        restaurantCoordinator.start()

        restaurantNav.tabBarItem = UITabBarItem(
            title: "Restaurants",
            image: UIImage(systemName: "fork.knife"),
            tag: 0
        )

        tabBarController.viewControllers = [restaurantNav]
        childCoordinators = [restaurantCoordinator]
    }
}

// MARK: - RestaurantListCoordinatorDelegate
extension MainTabBarCoordinator: RestaurantListCoordinatorDelegate {
    func didRequestLogout(from coordinator: RestaurantListCoordinator) {
        delegate?.didRequestLogout(from: self)
    }
}

