//
//  UICollectionView+EmptyMessage.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 12/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func setEmptyMessage() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = "There are currently no favorites."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    /// Removes the empty message and sets the background view to nil.
    func restore() {
        self.backgroundView = nil
    }
    
}
