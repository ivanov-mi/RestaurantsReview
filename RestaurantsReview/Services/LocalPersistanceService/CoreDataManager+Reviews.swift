//
//  CoreDataManager+Reviews.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import CoreData

extension CoreDataManager {
    
    // TODO: - Refactor
    
    func addReview(restaurantId: UUID, userId: UUID, comment: String, rating: Int, dateOfVisit: Date) -> Review? {
        let restaurantRequest: NSFetchRequest<RestaurantEntity> = RestaurantEntity.fetchRequest()
        restaurantRequest.predicate = NSPredicate(format: "id == %@", restaurantId as CVarArg)

        let userRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)

        do {
            guard let restaurantEntity = try context.fetch(restaurantRequest).first else {
                print("Restaurant not found for ID: \(restaurantId)")
                return nil
            }

            guard let userEntity = try context.fetch(userRequest).first else {
                print("User not found for ID: \(userId)")
                return nil
            }

            let reviewEntity = ReviewEntity(context: context)
            reviewEntity.id = UUID()
            reviewEntity.rating = Int64(rating)
            reviewEntity.comment = comment
            reviewEntity.dateOfVisit = dateOfVisit
            reviewEntity.dateCreated = Date()
            reviewEntity.restaurant = restaurantEntity
            reviewEntity.user = userEntity

            saveContext()

            return Review(
                id: reviewEntity.id!,
                rating: Int(reviewEntity.rating),
                comment: reviewEntity.comment ?? "",
                dateOfVisit: reviewEntity.dateOfVisit ?? dateOfVisit,
                dateCreated: reviewEntity.dateCreated ?? Date(),
                userId: userId,
                restaurantId: restaurantId
            )
        } catch {
            print("Failed to add review: \(error)")
            return nil
        }
    }
    
    func fetchAllReviews() -> [Review] {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()

        do {
            let results = try context.fetch(request)
            return results.compactMap { entity in
                guard let id = entity.id,
                      let comment = entity.comment,
                      let dateOfVisit = entity.dateOfVisit,
                      let dateCreated = entity.dateCreated,
                      let restaurantId = entity.restaurant?.id,
                      let userId = entity.user?.id else {
                    return nil
                }

                return Review(
                    id: id,
                    rating: Int(entity.rating),
                    comment: comment,
                    dateOfVisit: dateOfVisit,
                    dateCreated: dateCreated,
                    userId: userId,
                    restaurantId: restaurantId
                )
            }
        } catch {
            print("Failed to fetch all reviews: \(error)")
            return []
        }
    }
    
    func fetchReview(by id: UUID) -> Review? {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            if let entity = try context.fetch(request).first,
               let comment = entity.comment,
               let dateOfVisit = entity.dateOfVisit,
               let dateCreated = entity.dateCreated,
               let userId = entity.user?.id,
               let restaurantId = entity.restaurant?.id,
               let reviewId = entity.id {
                return Review(
                    id: reviewId,
                    rating: Int(entity.rating),
                    comment: comment,
                    dateOfVisit: dateOfVisit,
                    dateCreated: dateCreated,
                    userId: userId,
                    restaurantId: restaurantId
                )
            }
        } catch {
            print("Failed to fetch review by ID: \(error)")
        }

        return nil
    }

    func fetchReviews(for restaurantId: UUID) -> [Review] {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "restaurant.id == %@", restaurantId as CVarArg)

        do {
            let entities = try context.fetch(request)

            return entities.compactMap { entity in
                guard let id = entity.id,
                      let comment = entity.comment,
                      let dateOfVisit = entity.dateOfVisit,
                      let dateCreated = entity.dateCreated,
                      let restaurant = entity.restaurant,
                      let user = entity.user,
                      let restaurantID = restaurant.id,
                      let userID = user.id else {
                    return nil
                }

                return Review(
                    id: id,
                    rating: Int(entity.rating),
                    comment: comment,
                    dateOfVisit: dateOfVisit,
                    dateCreated: dateCreated,
                    userId: userID,
                    restaurantId: restaurantID
                )
            }
        } catch {
            print("Failed to fetch reviews for restaurant \(restaurantId): \(error)")
            return []
        }
    }

    func deleteReview(reviewId: UUID) {
        let request: NSFetchRequest<ReviewEntity> = ReviewEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", reviewId as CVarArg)

        do {
            if let review = try context.fetch(request).first {
                context.delete(review)
                saveContext()
            } else {
                print("Review not found for ID: \(reviewId)")
            }
        } catch {
            print("Failed to delete review: \(error)")
        }
    }
    
    func deleteAllReviews() {
        deleteAllEntities(named: "ReviewEntity")
    }
}
