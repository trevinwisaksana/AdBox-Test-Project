//
//  AdvertisementService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol AdvertisementServiceDelegate {
    func fetchJSONData(completion: @escaping ([JSON], Error?) -> Void)
    func fetchAdvertisements(success: @escaping SuccessOperationClosure)
}

struct AdvertisementService {
    
    // MARK: - Properties
    
    var coreDataStack = CoreDataStack()
    
    // MARK: - Fetching
    
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
    
    func fetchAdvertisements(success: @escaping SuccessOperationClosure) {
        var jsonData = [JSON]()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchJSONData { (data, error) in
            if let _ = error {
                success(false)
            }
            
            jsonData = data
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .global()) {
            self.coreDataStack.saveJSON(data: jsonData, success: success)
        }
    }

}
