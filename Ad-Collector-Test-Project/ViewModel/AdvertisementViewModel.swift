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
    
    fileprivate var advertisements = [Advertisement]() {
        didSet {
            delegate?.refresh()
        }
    }
    
    var contentIsEmpty: Bool {
        return advertisements.isEmpty
    }
    
    var favoriteAdsIsEmpty: Bool {
        return favoriteAdvertisements.isEmpty
    }
    
    //---- Liked advertisement ----//
    
    fileprivate var favoriteAdvertisements = [FavoriteAd]() {
        didSet {
            delegate?.refresh()
        }
    }
  
    //---- Array Count ----//
    
    var numberOfContents: Int {
        return advertisements.count
    }
    
    var numberOfFavoriteAds: Int {
        return favoriteAdvertisements.count
    }
    
    //---- Indexing ----//
    
    func contentData(atIndex index: Int) -> Advertisement {
        return advertisements[index]
    }
    
    func favoriteAd(atIndex index: Int) -> FavoriteAd {
        return favoriteAdvertisements[index]
    }
    
    //---- Load Operation ----//
    
    func loadAdvertisements() {
        advertisementService.fetchAdvertisements() { (advertisements, error) in
            if let error = error {
                // TODO: Error handle
                return
            }
            
            if advertisements.isEmpty {
                return
            }
            
            self.advertisements = advertisements
        }
    }
    
    func loadCachedAdvertisements(completion: @escaping (Error?) -> Void) {
        advertisementService.retrieveCachedAds { (advertisement, error) in
            if let error = error {
                completion(error)
            }
            
            self.advertisements = advertisement
            completion(nil)
        }
    }
    
    //---- Like Service ----//
    
    func fetchLikedAdvertisements() {
        likeService.retrieveFavoriteAds(completion: { (favoriteAds, error) in
            if error == nil {
                self.favoriteAdvertisements = favoriteAds
            }
        })
    }
    
    func setLikeForAdvertisement(at indexPath: IndexPath) {
        var advertisementKey: String?
        
        if isDisplayingFavorites {
            advertisementKey = favoriteAd(atIndex: indexPath.row).key
        } else {
            advertisementKey = contentData(atIndex: indexPath.row).key
        }
        
        guard let key = advertisementKey else {
            return
        }
        
        if let _ = CoreDataStack.shared.fetchSelectedFavoriteAd(withKey: key) {
            unlikeAdvertisement(at: indexPath)
        } else {
            
            likeAdvertisement(at: indexPath)
        }
    }
    
    func unlikeAdvertisement(at indexPath: IndexPath) {
        let ad = favoriteAdvertisements[indexPath.row]
        likeService.unlike(ad)
        favoriteAdvertisements.remove(at: indexPath.row)
    }
    
    func likeAdvertisement(at indexPath: IndexPath) {
        let ad = advertisements[indexPath.row]
        likeService.like(ad)
    }
    
}
