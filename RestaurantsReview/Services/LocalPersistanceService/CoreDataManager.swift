//
//  CoreDataManager.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import CoreData
import UIKit

class CoreDataManager: PersistenceManaging {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()

    // MARK: - Private Init
    private init() {
        persistentContainer = NSPersistentContainer(name: "RestaurantsReview")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
    }

    // MARK: - Core Data Stack
    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core Data Save Error: \(error)")
            }
        }
    }
    
    // MARK: - Batch Deletion with Merge + Reset
    func deleteAllEntities(named entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }

            context.reset()
        } catch {
            print("Failed to delete \(entityName): \(error)")
        }
    }
}

