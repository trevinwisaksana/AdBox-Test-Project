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

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    func newFavoriteAd() -> FavoriteAd {
        let favoriteAd = NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.favoriteAd, into: context) as! FavoriteAd
        return favoriteAd
    }
    
    func save()  {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    func delete(_ adveritsement: FavoriteAd){
        context.delete(adveritsement)
        save()
    }
    
    func retrieveFavoriteAds(completion: @escaping ([FavoriteAd], Error?) -> Void?) {
        context.perform {
            do {
                let fetchRequest = NSFetchRequest<FavoriteAd>(entityName: Constants.Entity.favoriteAd)
                let results = try self.context.fetch(fetchRequest)
                completion(results, nil)
            } catch let error {
                print("Could not fetch \(error.localizedDescription)")
                completion([FavoriteAd](), error)
            }
        }
    }
    
    func fetchSelectedFavoriteAd(withKey key: String) -> FavoriteAd? {
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



