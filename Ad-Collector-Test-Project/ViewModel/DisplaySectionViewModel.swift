//
//  DisplaySectionViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 18/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

final class DisplaySectionViewModel {
    
    fileprivate var content = [Advertisement]() {
        didSet {
            delegate?.contentChange()
        }
    }
    
    weak var delegate: AdvertisementDataSourceDelegate?
    
    var numberOfItems: Int {
        return content.count
    }
    
    func data(atIndex index: Int) -> Advertisement {
        return content[index]
    }
    
    func loadContent(_ data: [Advertisement]) {
        content = data
    }
    
    func determineSectionTitle() -> String {
        let advertisement = content[0]
        
        switch advertisement.type {
        case "BAP":
            return "Books"
        case "REALESTATE":
            return "Real Estate"
        case "CAR":
            return "Cars"
        default:
            fatalError("Error: unexpected type.")
        }
    }
    
}
