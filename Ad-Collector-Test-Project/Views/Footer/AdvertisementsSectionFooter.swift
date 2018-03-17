//
//  AdvertisementSectionFooter.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 18/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol DisplayMoreAdsDelegate: class {
    func pass(section: Int)
}

final class AdvertisementsSectionFooter: UICollectionReusableView {
    
    weak var delegate: DisplayMoreAdsDelegate?
    var section: Int?
    
    @IBAction func didTapSeeMoreButton(_ sender: UIButton) {
        if let section = section {
            delegate?.pass(section: section)
        }
    }
    
}
