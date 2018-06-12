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

protocol AdvertisementServiceProtocol: class {
    func updateAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func fetchAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func retrieveCachedAds(completion: @escaping AdvertisementOperationClosure)
    func retrieveFavoriteAdvertisements(completion: @escaping AdvertisementOperationClosure)
    func removeOutdatedData(success: @escaping SuccessOperationClosure)
}

class AdvertisementService: AdvertisementServiceProtocol {
    
    //---- Properties -----//
    
    private let baseURL = URL(string: "https://gist.githubusercontent.com/3lvis/3799feea005ed49942dcb56386ecec2b/raw/63249144485884d279d55f4f3907e37098f55c74/discover.json")
    
    var coreDataStack = CoreDataStack()
    
    //---- Fetching Advertisement ----//
    
    func fetchJSONData(completion: @escaping ([JSON], Error?) -> Void) {
        guard let url = baseURL else {
            return
        }
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                
                guard let jsonArray = JSON(data)["items"].array else {
                    completion([JSON](), nil)
                    return
                }
                
                completion(jsonArray, nil)
                
            case .failure(let error):
                completion([JSON](), error)
            }
        }
        
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
    
    func updateAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        coreDataStack.purgeData { (isSuccessful) in
            if isSuccessful {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .global()) {
            self.fetchAdvertisements { (advertisements, error) in
                completion(advertisements, error)
            }
        }
    }
    
    // Checks if the response has already by cached
    func retrieveCachedAds(completion: @escaping AdvertisementOperationClosure) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        coreDataStack.retrieveAdvertisements { (advertisements, error) in
            if advertisements.isEmpty {
                dispatchGroup.leave()
            } else {
                completion(advertisements, error)
            }
        }
        
        dispatchGroup.notify(queue: .global()) {
            self.fetchAdvertisements { (advertisement, error) in
                if let error = error {
                    completion([Advertisement](), error)
                    return
                }
                
                completion(advertisement, nil)
            }
        }
    }
    
    func retrieveFavoriteAdvertisements(completion: @escaping AdvertisementOperationClosure) {
        coreDataStack.retrieveLikedAdvertisements(completion: completion)
    }
    
    func removeOutdatedData(success: @escaping SuccessOperationClosure) {
        coreDataStack.purgeData(success: success)
    }
    
}
