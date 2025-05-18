//
//  PersistanceStoring.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

protocol PersistenceStoring: UserStoring & ReviewStoring & RestaurantStoring {}

protocol UserStoring {
    func create(_ user: User)
    func fetch(by id: UUID) -> User?
    func update(_ user: User)
    func delete(_ user: User)
}

protocol ReviewStoring {
    func create(_ review: Review)
    func fetch(by id: UUID) -> Review?
    func update(_ review: Review)
    func delete(_ review: Review)
    
    func reviews(forUser id: UUID) -> [Review]
    func reviews(forRestaurant id: UUID) -> [Review]
}

protocol RestaurantStoring {
    func create(_ restaurant: Restaurant)
    func fetch(by id: UUID) -> Restaurant?
    func update(_ restaurant: Restaurant)
    func delete(_ restaurant: Restaurant)
}
