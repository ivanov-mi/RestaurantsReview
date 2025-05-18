//
//  CoreDataManager+Users.swift
//  RestaurantsReview
//
//  Created by Martin Ivanov on 5/18/25.
//

import CoreData

extension CoreDataManager {
    
    // TODO: - Refactor
    
    func registerUser(username: String, email: String, password: String, isAdmin: Bool) -> User? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email ==[c] %@", email)

        do {
            let existing = try context.fetch(request)
            guard existing.isEmpty else {
                print("Email already registered")
                return nil
            }

            let entity = UserEntity(context: context)
            entity.id = UUID()
            entity.username = username
            entity.email = email
            entity.password = password
            entity.isAdmin = isAdmin

            saveContext()

            return User(id: entity.id!, email: email, username: username, isAdmin: isAdmin)
        } catch {
            print("Register error: \(error)")
            return nil
        }
    }

    func login(email: String, password: String) -> User? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email ==[c] %@ AND password == %@", email, password)

        do {
            let users = try context.fetch(request)
            guard let entity = users.first else {
                print("Invalid credentials")
                return nil
            }

            return User(
                id: entity.id!,
                email: entity.email!,
                username: entity.username ?? "",
                isAdmin: entity.isAdmin
            )
        } catch {
            print("Login error: \(error)")
            return nil
        }
    }
    
    func fetchUser(by id: UUID) -> User? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            if let entity = try context.fetch(request).first,
               let email = entity.email,
               let username = entity.username,
               let userId = entity.id {
                return User(
                    id: userId,
                    email: email,
                    username: username,
                    isAdmin: entity.isAdmin
                )
            }
        } catch {
            print("Failed to fetch user by ID: \(error)")
        }

        return nil
    }

    func fetchAllUsers() -> [User] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let users = try context.fetch(request)
            let mappedUsers: [User] = users.compactMap { entity in
                guard let id = entity.id,
                      let email = entity.email,
                      let username = entity.username else {
                    return nil
                }
                
                return User(id: id, email: email, username: username, isAdmin: entity.isAdmin)
            }
            
            return mappedUsers
        } catch {
            print("Fetch users error: \(error)")
            return []
        }
    }
    
    func changeAdminStatus(for userId: UUID, to isAdmin: Bool) -> User? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do {
            guard let userEntity = try context.fetch(request).first else {
                print("User not found.")
                return nil
            }
            
            userEntity.isAdmin = isAdmin
            saveContext()
            
            guard let id = userEntity.id,
                  let email = userEntity.email,
                  let username = userEntity.username else {
                print("Invalid user data.")
                return nil
            }
            
            let updatedUser = User(id: id, email: email, username: username, isAdmin: isAdmin)
            return updatedUser
            
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func deleteUser(userId: UUID) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", userId as CVarArg)

        do {
            if let user = try context.fetch(request).first {
                context.delete(user)
                saveContext()
            } else {
                print("User not found for ID: \(userId)")
            }
        } catch {
            print("Failed to delete user: \(error)")
        }
    }
    
    func deleteAllUsers() {
        deleteAllEntities(named: "UserEntity")
    }
}
