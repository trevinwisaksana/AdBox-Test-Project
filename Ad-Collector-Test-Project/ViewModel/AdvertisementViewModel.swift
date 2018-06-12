//
//  AdvertisementViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

protocol AdvertisementDataSourceDelegate: class {
    func refresh()
}

final class AdvertisementViewModel {
    
    //---- Properties ----//
    
    weak var delegate: AdvertisementDataSourceDelegate?
    
    var advertisementService: AdvertisementService
    var likeService: LikeService
    
    var isDisplayingFavorites = false
    
    //---- Initializer ----//
    
    init(adService: AdvertisementService, likeService: LikeService) {
        self.advertisementService = adService
        self.likeService = likeService
    }
    
    //---- Advertisements ----//
    
    private var advertisements = [Advertisement]() {
        didSet {
            delegate?.refresh()
        }
    }
    
    private var likedAdvertisements = [Advertisement]() {
        didSet {
            delegate?.refresh()
        }
    }
    
    var advertisementIsEmpty: Bool {
        return advertisements.isEmpty
    }
    
    var likedAdvertisementIsEmpty: Bool {
        return likedAdvertisements.isEmpty
    }
  
    //---- Data Count ----//
    
    var advertisementCount: Int {
        return advertisements.count
    }
    
    var favoriteAdvertisementCount: Int {
        return likedAdvertisements.count
    }
    
    //---- Indexing ----//
    
    func advertisement(atIndex index: Int) -> Advertisement {
        return advertisements[index]
    }
    
    func likedAdvertisement(atIndex index: Int) -> Advertisement {
        return likedAdvertisements[index]
    }
    
    //---- Load Operation ----//
    
    func loadAdvertisements(completion: @escaping (Error?) -> Void) {
        advertisementService.updateAdvertisements() { (advertisements, error) in
            if let error = error {
                completion(error)
                return
            }
            
            self.advertisements = advertisements
            completion(nil)
        }
    }
    
    func loadCachedAdvertisements(completion: @escaping (Error?) -> Void) {
        advertisementService.retrieveCachedAds { (advertisements, error) in
            if let error = error {
                completion(error)
            }
            
            self.advertisements = advertisements
            completion(nil)
        }
    }
    
    //---- Like Service ----//
    
    func updateLikeStatus(forItemAt indexPath: IndexPath) {
        
        var adSelected: Advertisement
        
        if isDisplayingFavorites {
            adSelected = likedAdvertisement(atIndex: indexPath.row)
        } else {
            adSelected = advertisement(atIndex: indexPath.row)
        }
        
        likeService.setLike(status: adSelected.isLiked, for: adSelected) { (success) in
            if self.isDisplayingFavorites {
                self.likedAdvertisements.remove(at: indexPath.row)
                self.delegate?.refresh()
            }
        }
    }
    
    func fetchFavoriteAdvertisements() {
        advertisementService.retrieveFavoriteAdvertisements { (advertisements, error) in
            if let error = error {
                // TODO: Error handling
                print("\(error.localizedDescription)")
            } else {
                self.likedAdvertisements = advertisements
            }
        }
    }
    
}
