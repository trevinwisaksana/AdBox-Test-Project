//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

class LikeService {
    
    var coreDataStack = CoreDataStack()
    
    func like(_ advertisement: Advertisement?) {
        guard let data = advertisement else {
            return
        }
        
        let newFavoriteAd = coreDataStack.newFavoriteAd()
        
        newFavoriteAd.isLiked = true
        newFavoriteAd.location = data.location
        newFavoriteAd.posterURL = data.photoURL
        newFavoriteAd.title = data.title
        
        newFavoriteAd.price = Double(data.price)
        newFavoriteAd.key = data.key
        
        coreDataStack.save()
    }
    
    func unlike(_ advertisement: FavoriteAd) {
        if let key = advertisement.key {
            UserDefaults.standard.removeObject(forKey: "\(key)")
            coreDataStack.delete(advertisement)
            coreDataStack.save()
        }
    }
    
    func retrieveFavoriteAds(completion: @escaping ([FavoriteAd], Error?) -> Void) {
        coreDataStack.retrieveFavoriteAds(completion: { (favoriteAds, error) in
            completion(favoriteAds, error)
        })
    }
    
}
