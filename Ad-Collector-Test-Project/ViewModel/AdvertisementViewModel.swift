//
//  AdvertisementViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

protocol AdvertisementViewModelDelegate: class {
    func refresh()
    func showError(message: ErrorType)
}

final class AdvertisementViewModel {
    
    //---- Properties ----//
    
    weak var delegate: AdvertisementViewModelDelegate?
    
    var advertisementService: AdvertisementService
    var likeService: LikeService
    
    var isDisplayingFavorites = false
    
    var onErrorHandling: ((Error) -> Void)?
    
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
    
    func loadAdvertisements() {
        advertisementService.updateAdvertisements() { (advertisements, error) in
            if let _ = error {
                self.delegate?.showError(message: .failedToFetchData)
                return
            }
            
            self.advertisements = advertisements
        }
    }
    
    func loadCachedAdvertisements() {
        advertisementService.retrieveCachedAds { (advertisements, error) in
            if let _ = error {
                self.delegate?.showError(message: .failedToFetchData)
                return
            }
            
            self.advertisements = advertisements
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
            if let _ = error {
                self.delegate?.showError(message: .failedToFetchData)
                return
            } else {
                self.likedAdvertisements = advertisements
            }
        }
    }
    
}
