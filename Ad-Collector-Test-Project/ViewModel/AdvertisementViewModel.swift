//
//  AdvertisementViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

protocol AdvertisementDataSourceDelegate: class {
    func contentChange()
}

final class AdvertisementViewModel {
    
    //---- Properties ----//
    
    weak var delegate: AdvertisementDataSourceDelegate?
    
    var advertisementService: AdvertisementService
    var likeService: LikeService
    
    //---- Initializer ----//
    
    init(adService: AdvertisementService, likeService: LikeService) {
        self.advertisementService = adService
        self.likeService = likeService
    }
    
    fileprivate var content = [Advertisement]() {
        didSet {
            delegate?.contentChange()
        }
    }
    
    var contentIsEmpty: Bool {
        return content.isEmpty
    }
    
    //---- Most Popular Content ----//
    
    fileprivate var mostPopularContent: [Advertisement] {
        let popularContent = content.filter { (advertisement) -> Bool in
            advertisement.score > 0.8
        }
        
        return popularContent
    }
    
    //---- Liked advertisement ----//
    
    fileprivate var favoriteAdvertisements = CoreDataHelper.retrieveFavoriteAds()
    
    //---- Cars Content -----//
    
    // Used to be passed to the DisplaySectionVC
    fileprivate var carsContent: [Advertisement] {
        let carsContent = content.filter { (advertisement) -> Bool in
            advertisement.type == Constants.AdType.car
        }
        
        return carsContent
    }
    
    // Used to be passed to the AdvertisementsVC
    fileprivate var popularCarsContent: [Advertisement] {
        let popularCarsContent = carsContent.filter { (advertisement) -> Bool in
            advertisement.score > 0.28
        }
        
        return popularCarsContent
    }
    
    //---- Real Estate Content ----//
    
    // Used to be passed to the DisplaySectionVC
    fileprivate var realEstateContent: [Advertisement] {
        let realEstateContent = content.filter { (advertisement) -> Bool in
            advertisement.type == Constants.AdType.realEstate
        }
        
        return realEstateContent
    }
    
    // Used to be passed to the AdvertisementsVC
    fileprivate var popularRealEstateContent: [Advertisement] {
        let popularRealEstateContent = realEstateContent.filter { (advertisement) -> Bool in
            advertisement.score > 0.7
        }
        
        return popularRealEstateContent
    }
    
    //---- BAP Content ----//
    
    // Used to be passed to the DisplaySectionVC
    fileprivate var bapContent: [Advertisement] {
        let bapContent = content.filter { (advertisement) -> Bool in
            advertisement.type == Constants.AdType.bap
        }
        
        return bapContent
    }
    
    // Used to be passed to the AdvertisementsVC
    fileprivate var popularBapContent: [Advertisement] {
        let popularBapContent = bapContent.filter { (advertisement) -> Bool in
            advertisement.score > 0.8
        }
        
        return popularBapContent
    }
    
    
    //---- Array Count ----//
    
    var numberOfItems: Int {
        return content.count
    }
    
    var numberOfPopularContent: Int {
        return mostPopularContent.count
    }
    
    var numberOfCarContent: Int {
        return popularCarsContent.count
    }
    
    var numberOfRealEstateContent: Int {
        return popularRealEstateContent.count
    }
    
    var numberOfBapContent: Int {
        return popularBapContent.count
    }
    
    //---- Indexing ----//
    
    func contentData(atIndex index: Int) -> Advertisement {
        return content[index]
    }
    
    func carsContentData(atIndex index: Int) -> Advertisement {
        return carsContent[index]
    }
    
    func realEstateContentData(atIndex index: Int) -> Advertisement {
        return realEstateContent[index]
    }
    
    func bapContentData(atIndex index: Int) -> Advertisement {
        return bapContent[index]
    }
    
    func mostPopularContentData(atIndex index: Int) -> Advertisement {
        return mostPopularContent[index]
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
    
    func passData(fromSection section: Int) -> [Advertisement] {
        switch section {
        case 1:
            return carsContent
        case 2:
            return bapContent
        case 3:
            return realEstateContent
        default:
            fatalError("Error: unexpected section.")
        }
    }
    
    //---- Like Service ----//
    
    func removeLike(for ad: FavoriteAd) {
        likeService.remove(ad)
    }
    
    func likeAdvertisement(for ad: Advertisement?) {
        likeService.saveToFavorite(ad)
    }
    
}
