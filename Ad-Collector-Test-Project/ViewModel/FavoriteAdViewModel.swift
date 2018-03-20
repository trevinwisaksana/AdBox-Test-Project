//
//  FavoriteAdViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import CoreData

final class FavoriteAdViewModel {
    
    //---- Properties ----//
    
    weak var delegate: AdvertisementDataSourceDelegate?
    
    var likeService: LikeService
    
    //---- Initializer ----//
    
    init(service: LikeService) {
        self.likeService = service
    }
    
    //---- Data Source ----//
    
    private var content = CoreDataHelper.retrieveFavoriteAds() {
        didSet {
            delegate?.contentChange()
        }
    }
    
    //---- Data Source Properties ----//
    
    var numberOfItems: Int {
        return content.count
    }
    
    var contentIsEmpty: Bool {
        return content.isEmpty
    }
    
    func data(atIndex index: Int) -> FavoriteAd {
        return content[index]
    }
    
    func fetchFavoriteAds() {
        content = CoreDataHelper.retrieveFavoriteAds()
    }
    
    func removeLike(for ad: FavoriteAd) {
        likeService.remove(ad)
    }
    
}
