//
//  AppStoryboard.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/16/25.
//

import UIKit

enum AppStoryboard: String {
    case main = "Main"

    var instance: UIStoryboard {
        UIStoryboard(name: self.rawValue, bundle: nil)
    }

    func viewController<T: UIViewController>(ofType type: T.Type) -> T {
        let identifier = String(describing: T.self)
        guard let viewController = instance.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("ViewController '\(identifier)' not found in storyboard '\(rawValue)'")
        }
        return viewController
    }
}
