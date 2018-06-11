//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

class LikeService {
    
    func saveToFavorite(_ data: Advertisement?) {
        guard let data = data else {
            return
        }
        
        let newFavoriteAd = CoreDataHelper.newFavoriteAd()
        
        newFavoriteAd.isLiked = true
        newFavoriteAd.location = data.location
        newFavoriteAd.posterURL = data.photoURL
        newFavoriteAd.title = data.title
        
        newFavoriteAd.price = Double(data.price)
        newFavoriteAd.key = data.key
        
        CoreDataHelper.save()
    }
    
    func remove(_ data: FavoriteAd) {
        if let key = data.key {
            UserDefaults.standard.removeObject(forKey: "\(key)")
            CoreDataHelper.delete(ad: data)
            CoreDataHelper.save()
        }
    }
    
    func retrieveFavoriteAds() -> [FavoriteAd] {
        return CoreDataHelper.retrieveFavoriteAds()
    }
    
}
