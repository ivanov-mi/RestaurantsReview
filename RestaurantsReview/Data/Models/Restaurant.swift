//
//  Restaurant.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import Foundation

struct Restaurant: Hashable {
    let id: UUID
    var name: String
    var cuisine: String
    var imagePath: String?
}
