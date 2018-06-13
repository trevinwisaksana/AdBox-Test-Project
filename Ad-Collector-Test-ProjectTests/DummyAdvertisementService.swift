//
//  DummyAdvertisementService.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 20/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import Ad_Collector_Test_Project

struct DummyAdvertisementService: AdvertisementServiceDelegate {
    
    // MARK: - Properties
    
    var coreDataStack = CoreDataStack()
    
    // MARK: - Fetching Data
    
    func fetchJSONData(completion: @escaping ([JSON], Error?) -> Void) {
        
    }
    
    func fetchAdvertisements(success: @escaping SuccessOperationClosure) {
        
    }
    
}
