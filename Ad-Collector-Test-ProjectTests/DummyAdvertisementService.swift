//
//  DummyAdvertisementService.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 20/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

@testable import Ad_Collector_Test_Project

class DummyAdvertisementService: AdvertisementService {
    
    var data: [Advertisement]
    
    init(data: [Advertisement]) {
        self.data = data
    }
    
    override func retrieveCachedAds(completion: @escaping ([Advertisement], Error?) -> Void) {
        completion(data, nil)
    }
    
    override func fetchAdvertisements(completion: @escaping ([Advertisement], Error?) -> Void) {
        completion(data, nil)
    }
    
}
