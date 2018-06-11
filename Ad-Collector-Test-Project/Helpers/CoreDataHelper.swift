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

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newFavoriteAd() -> FavoriteAd {
        let favoriteAd = NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.favoriteAd, into: context) as! FavoriteAd
        
        return favoriteAd
    }
    
    static func save()  {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(ad: FavoriteAd){
        context.delete(ad)
        save()
    }
    
    static func retrieveFavoriteAds() -> [FavoriteAd] {
        do {
            let fetchRequest = NSFetchRequest<FavoriteAd>(entityName: Constants.Entity.favoriteAd)
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return[]
        }
    }
    
    static func fetchSelectedFavoriteAd(withKey key: String) -> FavoriteAd? {
        do {
            let fetchRequest = NSFetchRequest<FavoriteAd>(entityName: Constants.Entity.favoriteAd)
            let results = try context.fetch(fetchRequest)
            
            var output: FavoriteAd?
            
            results.forEach() { (ad) in
                if ad.key == key {
                    output = ad
                }
            }
            
            return output
            
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return nil
        }
    }
}



