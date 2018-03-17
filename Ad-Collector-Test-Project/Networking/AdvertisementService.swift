//
//  AdvertisementService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct AdvertisementService {
    
    private static let baseURL = URL(string: "https://gist.githubusercontent.com/3lvis/3799feea005ed49942dcb56386ecec2b/raw/63249144485884d279d55f4f3907e37098f55c74/discover.json")
    
    static func fetchAdvertisements(completion: @escaping ([Advertisement], Error?) -> Void) {
        
        guard let url = baseURL else { return }
        
        // Checks if the a response has already by cached
        // NOTE: This is specific to this project to prevent repeated downloads of the static data
        if  let request = Alamofire.request(url).request,
            let data = URLCache.shared.cachedResponse(for: request)?.data {
            
            guard let jsonArray = JSON(data)["items"].array else {
                return
            }
            
            let advertisements = jsonArray.flatMap { Advertisement(with: $0) }
            
            completion(advertisements, nil)
            return
        }
    
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                guard let jsonArray = JSON(data)["items"].array else {
                    completion([Advertisement](), nil)
                    return
                }
                
                let advertisements = jsonArray.flatMap { Advertisement(with: $0) }
                
                // Caching the parsed data
                if  let request = response.request,
                    let data = response.data, let response = response.response {
                    let cachedResponse = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                }
 
                completion(advertisements, nil)
                
            case .failure(let error):
                completion([Advertisement](), error)
            }
        }
    }
    
}
