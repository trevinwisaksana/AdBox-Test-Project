//
//  AdvertisementService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol AdvertisementServiceProtocol: class {
    func updateAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func fetchAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func retrieveCachedAds(completion: @escaping AdvertisementOperationClosure)
    func retrieveFavoriteAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func removeOutdatedData(success: @escaping SuccessOperationClosure)
}

final class AdvertisementService {
    
    //---- Properties -----//
    
    var coreDataStack = CoreDataStack()
    
    //---- Fetching Advertisement ----//
    
    func fetchJSONData(completion: @escaping ([JSON], Error?) -> Void) {
        
        let baseURL = URL(string: "https://gist.githubusercontent.com/3lvis/3799feea005ed49942dcb56386ecec2b/raw/63249144485884d279d55f4f3907e37098f55c74/discover.json")
        
        guard let url = baseURL else {
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            
            if let error = error {
                completion([JSON](), error)
            } else if let data = data, let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 {
                
                guard let jsonData = JSON(data)["items"].array else {
                    completion([JSON](), nil)
                    return
                }
                
                completion(jsonData, nil)
            }
            
        })
        
        dataTask?.resume()
    }
    
    func fetchAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        var jsonData = [JSON]()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchJSONData { (data, error) in
            jsonData = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            self.coreDataStack.saveJSON(data: jsonData) { (advertisements, error) in
                completion(advertisements, error)
            }
        }
    }

}
