//
//  Advertisement.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

struct Advertisement {

    var title: String
    var price: Int
    var photoURL: String
    var location: String
    var key: String
    var type: String
    var score: Double

    var isFavorite = false

    init?(with json: JSON) {
        guard let title = json["description"].string else {
            return nil
        }

        guard let price = json["price"]["value"].int else {
            return nil
        }

        guard let location = json["location"].string else {
            return nil
        }

        guard let adType = json["ad-type"].string else {
            return nil
        }

        guard let rawScoreResponseString = json["score"].string else {
            return nil
        }
        
        guard let score = Double(rawScoreResponseString) else {
            return nil
        }

        let key = json["id"].stringValue
        let photoURL = json["image"]["url"].string ?? ""

        self.title = title
        self.price = price
        self.location = location
        self.photoURL = photoURL
        self.key = key
        self.type = adType
        self.score = score
    }

}
