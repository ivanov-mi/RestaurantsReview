//
//  PersistenceManager.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()

    private var store: PersistenceStoring
    
    // TODO: Fix when integrating CoreData

    private init(store: PersistenceStoring = MockStore(testDataRequired: true)) {
        self.store = store
    }

    func setStore(_ store: PersistenceStoring) {
        self.store = store
    }

    var users: UserStoring { store }
    var reviews: ReviewStoring { store }
    var restaurants: RestaurantStoring { store }
}
