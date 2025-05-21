//
//  AdminCoordinator.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - AdminCoordinatorDelegate
protocol AdminCoordinatorDelegate: AnyObject {
    func didRequestLogout(from coordinator: AdminCoordinator)
    func didChangeAdminStatus(from coordinator: AdminCoordinator)
}

// MARK: - AdminCoordinator
class AdminCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let persistenceManager: PersistenceManaging
    private var childCoordinators: [Coordinator] = []
    
    weak var delegate: AdminCoordinatorDelegate?

    init(navigationController: UINavigationController, persistenceManager: PersistenceManaging) {
        self.navigationController = navigationController
        self.persistenceManager = persistenceManager
    }

    func start() {
        let adminVC = AppStoryboard.main.viewController(ofType: AdminViewController.self)
        adminVC.coordinator = self
        navigationController.setViewControllers([adminVC], animated: false)
    }
}


// MARK: - AdminViewControllerCoordinator
extension AdminCoordinator: AdminViewControllerCoordinator {
    func didSelectRestaurants(from controller: AdminViewController) {
        let restaurantCoordinator = RestaurantListCoordinator(navigationController: navigationController, persistenceManager: persistenceManager)
        restaurantCoordinator.pushRestaurantList(on: navigationController)
        
        childCoordinators.append(restaurantCoordinator)
    }
    
    func didSelectUsers(from controller: AdminViewController) {
        let usersVC = AppStoryboard.main.viewController(ofType: UserListingViewController.self)
        usersVC.coordinator = self
        usersVC.persistenceManager = persistenceManager
        navigationController.pushViewController(usersVC, animated: true)
    }
    
    func didSelectReviews(from controller: AdminViewController) {
        let reviewsVC = AppStoryboard.main.viewController(ofType: ReviewsListingViewController.self)
        reviewsVC.coordinator = self
        reviewsVC.persistenceManager = persistenceManager
        navigationController.pushViewController(reviewsVC, animated: true)
    }
}

// MARK: - UserListingViewControllerCoordinator
extension AdminCoordinator: UserListingViewControllerCoordinator {
    func currentUserDeleted(_ controller: UserListingViewController) {
            delegate?.didRequestLogout(from: self)
    }
    
    func didSelectUser(_ controller: UserListingViewController, user: User) {
        let profileVC = AppStoryboard.main.viewController(ofType: ProfileViewController.self)
        profileVC.persistenceManager = persistenceManager
        profileVC.user = user
        profileVC.delegate = controller
        profileVC.coordinator = self
 
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func didTapAddUser(_ controller: UserListingViewController) {
        let registerVC = AppStoryboard.main.viewController(ofType: RegisterViewController.self)
        registerVC.persistenceManager = persistenceManager
        registerVC.delegate = controller
        registerVC.coordinator = self
        
        let nav = UINavigationController(rootViewController: registerVC)
        controller.present(nav, animated: true)
    }
}

// MARK: - ReviewsListingViewControllerCoordinator
extension AdminCoordinator: ReviewsListingViewControllerCoordinator {
    func didSelectReview(_ controller: ReviewsListingViewController, review: Review) {
        let ReviewDetailsVC = AppStoryboard.main.viewController(ofType: ReviewDetailsViewController.self)
        ReviewDetailsVC.configure(
            with: review.userId,
            for: review.restaurantId,
            review: review
        )
        
        ReviewDetailsVC.persistenceManager = persistenceManager
        ReviewDetailsVC.coordinator = self
        ReviewDetailsVC.delegate = controller

        let navigationController = UINavigationController(rootViewController: ReviewDetailsVC)
        controller.present(navigationController, animated: true)
    }
}

// MARK: - ReviewDetailsViewControllerCoordinator
extension AdminCoordinator: ReviewDetailsViewControllerCoordinator {
    func didFinishCreatingReview(_ controller: ReviewDetailsViewController, review: Review) {
        controller.dismiss(animated: true)
    }

    func didCancelReviewCreation(_ controller: ReviewDetailsViewController) {
        controller.dismiss(animated: true)
    }
}

extension AdminCoordinator: ProfileViewControllerCoordinator {
    func didRequestLogout(from controller: ProfileViewController) {
        delegate?.didRequestLogout(from: self)
    }
    
    func didRemoveCurrentUserAdminStatus(from controller: ProfileViewController) {
        delegate?.didChangeAdminStatus(from: self)
    }
}

extension AdminCoordinator: RegisterViewControllerCoordinator {
    func didFinishRegistration(_ controller: RegisterViewController) {
        controller.dismiss(animated: true)
    }
}
