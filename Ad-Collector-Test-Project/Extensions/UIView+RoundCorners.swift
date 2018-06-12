//
//  UIView+RoundCorners.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 12/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorner(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMinYCorner]
    }
    
}
