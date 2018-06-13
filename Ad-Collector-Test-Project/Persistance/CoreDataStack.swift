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
    
    private let privateContext: NSManagedObjectContext = {
        var privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        privateContext.automaticallyMergesChangesFromParent = true
        privateContext.parent = persistentContainer.viewContext
        
        return privateContext
    }()
    
    // MARK: - Save
    
    func saveJSON(data: [JSON], success: @escaping SuccessOperationClosure) {
        
        if data.isEmpty {
            return
        }
        
        privateContext.perform {
            _ = data.compactMap { Advertisement(with: $0, isSaved: true) }
            success(true)
        }
    }
    
}
