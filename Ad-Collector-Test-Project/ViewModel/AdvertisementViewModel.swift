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
    
    var switchToggleIsOn = false
    
    //---- Initializer ----//
    
    init(adService: AdvertisementService, likeService: LikeService) {
        self.advertisementService = adService
        self.likeService = likeService
    }
    
    fileprivate var content = [Advertisement]() {
        didSet {
            delegate?.refresh()
        }
    }
    
    var contentIsEmpty: Bool {
        return content.isEmpty
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
        return content.count
    }
    
    var numberOfFavoriteAds: Int {
        return favoriteAdvertisements.count
    }
    
    //---- Indexing ----//
    
    func contentData(atIndex index: Int) -> Advertisement {
        return content[index]
    }
    
    func favoriteAd(atIndex index: Int) -> FavoriteAd {
        return favoriteAdvertisements[index]
    }
    
    //---- Load Operation ----//
    
    func loadAdvertisements(completion: @escaping (Error?) -> Void) {
        advertisementService.fetchAdvertisements() { (advertisements, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if advertisements.isEmpty {
                return
            }
            
            self.content = advertisements
            completion(nil)
        }
    }
    
    func loadCachedAdvertisements(completion: @escaping (Error?) -> Void) {
        advertisementService.retrieveCachedAds { (advertisement, error) in
            if let error = error {
                completion(error)
            }
            
            self.content = advertisement
            completion(nil)
        }
    }
    
    //---- Like Service ----//
    
    func fetchLikedAdvertisements() {
        favoriteAdvertisements = likeService.retrieveFavoriteAds()
    }
    
    func removeLike(for ad: FavoriteAd) {
        likeService.remove(ad)
    }
    
    func likeAdvertisement(for ad: Advertisement?) {
        likeService.saveToFavorite(ad)
    }
    
}
