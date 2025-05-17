//
//  MainTabBarController.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/17/25.
//

import UIKit

// MARK: - MainTabItem
enum MainTabItem: Int, CaseIterable {
    case restaurants
    case profile
    case admin

    var title: String {
        switch self {
        case .restaurants: 
            return "Restaurants"
        case .profile:     
            return "Profile"
        case .admin:       
            return "Admin"
        }
    }

    var icon: UIImage? {
        switch self {
        case .restaurants:
            return UIImage(systemName: "fork.knife")
        case .profile:
            return UIImage(systemName: "person")
        case .admin:
            return UIImage(systemName: "gearshape")
        }
    }
}

// MARK: - MainTabViewController
class MainTabViewController: UITabBarController {
    func configureTabs(_ tabItems: [(MainTabItem, UIViewController)]) {
        for (tab, controller) in tabItems {
            controller.tabBarItem = UITabBarItem(
                title: tab.title,
                image: tab.icon,
                selectedImage: nil
            )
        }

        self.viewControllers = tabItems.map { $0.1 }
    }
}
