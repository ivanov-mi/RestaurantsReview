//
//  CoreDataManager+Restaurants.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import CoreData

extension CoreDataManager {
    
    // TODO: - Refactor
    
    func createRestaurant(name: String, cuisine: String, imagePath: String? = nil) -> Restaurant? {
        let entity = RestaurantEntity(context: context)
        entity.id = UUID()
        entity.name = name
        entity.cuisine = cuisine
        entity.imagePath = imagePath

        saveContext()

        guard let id = entity.id, let name = entity.name, let cuisine = entity.cuisine else {
            print("Failed to create restaurant: Missing required fields")
            return nil
        }

        return Restaurant(id: id, name: name, cuisine: cuisine, imagePath: entity.imagePath)
    }
    
    func fetchAllRestaurants() -> [Restaurant] {
        let request: NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()

        do {
            let entities = try context.fetch(request)

            return entities.compactMap { entity in
                guard let id = entity.id,
                      let name = entity.name,
                      let cuisine = entity.cuisine else {
                    return nil
                }

                return Restaurant(
                    id: id,
                    name: name,
                    cuisine: cuisine,
                    imagePath: entity.imagePath
                )
            }
        } catch {
            print("Failed to fetch restaurants: \(error)")
            return []
        }
    }
    
    func averageRating(for restaurantId: UUID) -> Double? {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReviewEntity")
        request.resultType = .dictionaryResultType
        request.predicate = NSPredicate(format: "restaurant.id == %@", restaurantId as CVarArg)

        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "averageRating"
        expressionDesc.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "rating")])
        expressionDesc.expressionResultType = .doubleAttributeType

        request.propertiesToFetch = [expressionDesc]

        do {
            if let result = try context.fetch(request).first as? [String: Double],
               let average = result["averageRating"] {
                return average
            }
        } catch {
            print("Failed to compute average rating: \(error)")
        }

        return nil
    }

    func reviewCount(for restaurantId: UUID) -> Int {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ReviewEntity")
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "restaurant.id == %@", restaurantId as CVarArg)

        do {
            return try context.count(for: request)
        } catch {
            print("Failed to count reviews: \(error)")
            return 0
        }
    }
    
    func deleteRestaurant(restaurantId: UUID) {
        let request: NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", restaurantId as CVarArg)

        do {
            if let restaurant = try context.fetch(request).first {
                context.delete(restaurant)
                saveContext()
            } else {
                print("Restaurant not found for ID: \(restaurantId)")
            }
        } catch {
            print("Failed to delete restaurant: \(error)")
        }
    }
    
    func deleteAllRestaurants() {
        deleteAllEntities(named: "RestaurantEntity")
    }
}
