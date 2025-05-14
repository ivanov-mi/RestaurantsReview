//
//  UIWindow+CustomPush.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/14/25.
//

import UIKit

extension UIWindow {
    func applyPushTransition(duration: CFTimeInterval = 0.35) {
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromRight
        transition.duration = duration
        self.layer.add(transition, forKey: kCATransition)
    }
}
