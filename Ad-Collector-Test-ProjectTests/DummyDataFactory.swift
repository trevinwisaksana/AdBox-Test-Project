//
//  DummyDataFactory.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 20/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON

@testable import Ad_Collector_Test_Project

class DummyDataFactory {
    
    let discoverJSONPath = Bundle.main.path(forResource: "discover", ofType: "json")
    
    func dummyAdvertisements() -> [Advertisement] {
        
        guard let path = discoverJSONPath else {
            fatalError()
        }
        
        guard let discoverJSON = NSData(contentsOfFile: path) else {
            fatalError()
        }
        
        guard let jsonArray = JSON(discoverJSON)["items"].array else {
            return [Advertisement]()
        }
        
        let advertisements = jsonArray.flatMap { Advertisement(with: $0) }
        return advertisements
    }
    
}
