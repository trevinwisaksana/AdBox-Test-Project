//
//  CoreDataHelper.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftyJSON

struct CoreDataStack {
    
    //---- Properties ----//
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let persistentContainer: NSPersistentContainer = {
        let container = appDelegate.persistentContainer
        
        return container
    }()
    
    let persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        return coordinator
    }()
    
    let managedContext: NSManagedObjectContext = {
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    private let privateContext: NSManagedObjectContext = {
        var privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        privateContext.automaticallyMergesChangesFromParent = true
        privateContext.parent = persistentContainer.viewContext
        
        return privateContext
    }()
    
    var fetchResultsControler: NSFetchedResultsController<Advertisement> = {
        let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    // MARK: Save
    
    func saveJSON(data: [JSON], completion: @escaping AdvertisementOperationClosure) {
        
        if data.isEmpty {
            return
        }
        
        privateContext.perform {
            let advertisements = data.compactMap { Advertisement(with: $0, isSaved: true) }
            completion(advertisements, nil)
        }
    }
    
    func save(success: @escaping SuccessOperationClosure) {
        do {
            try privateContext.save()
            managedContext.performAndWait {
                do {
                    try managedContext.save()
                    success(true)
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    //---- Purge Data ----//
    
    func purgeData(success: @escaping SuccessOperationClosure) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.Entity.advertisement)
        // Only purge data that is not liked
        fetchRequest.predicate = NSPredicate(format: "isLiked == NO")
        fetchRequest.includesPropertyValues = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        privateContext.perform {
            do {
                try self.persistentStoreCoordinator.execute(deleteRequest, with: self.managedContext)
                success(true)
            } catch {
                success(false)
            }
        }
    }
    
    //---- Fetch ----//
    
    func retrieveAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        privateContext.perform {
            do {
                let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
                let results = try self.managedContext.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
    }
    
    func retrieveLikedAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        privateContext.perform {
            do {
                let fetchRequest = NSFetchRequest<User>(entityName: Constants.Entity.user)
                
                guard let user = try self.managedContext.fetch(fetchRequest).first else {
                    fatalError("User does not exist")
                }
                
                let results = user.likedAdvertisements?.allObjects as! [Advertisement]
                
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([Advertisement](), error)
            }
        }
        
    }
    
    //---- User ----//
    
    static func createUser() {
        _ = NSEntityDescription.insertNewObject(forEntityName: "User", into: persistentContainer.viewContext) as! User
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func addLiked(_ advertisement: Advertisement, success: @escaping SuccessOperationClosure) {
        advertisement.isLiked = true
        
        privateContext.perform {
            do {
                let fetchRequest = NSFetchRequest<User>(entityName: Constants.Entity.user)
                
                guard let user = try self.managedContext.fetch(fetchRequest).first else {
                    return
                }
                
                user.addToLikedAdvertisements(advertisement)
                
                self.save(success: success)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
            }
        }
    }
    
    func dislike(_ advertisement: Advertisement, success: @escaping SuccessOperationClosure) {
        advertisement.isLiked = false
        
        privateContext.perform {
            do {
                let fetchRequest = NSFetchRequest<User>(entityName: Constants.Entity.user)
                
                guard let user = try self.managedContext.fetch(fetchRequest).first else {
                    return
                }
                
                user.removeFromLikedAdvertisements(advertisement)
                
                self.save(success: success)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
            }
        }
    }
    
}
