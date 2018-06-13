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

class CoreDataStack {
    
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
    
    // MARK: - Save
    
    func saveJSON(data: [JSON], completion: @escaping AdvertisementOperationClosure) {
        
        if data.isEmpty {
            return
        }
        
        privateContext.perform {
            let advertisements = data.compactMap { Advertisement(with: $0, isSaved: true) }
            completion(advertisements, nil)
        }
    }
    
    // MARK: - Advertisement
    
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
    
}
