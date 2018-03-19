//
//  AdvertisementCollectionView.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class AdvertisementCollectionView: UICollectionView {
    
    //---- Properties ----//
    
    var animatedCellIndexPath = [IndexPath]()
    var didAnimateCellEntry = false
    
    //---- Animation ----//
    
    func animateCellEntry(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if !animatedCellIndexPath.contains(indexPath) && didAnimateCellEntry == false {
            
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            cell.layer.opacity = 0.0
            
            let delay = 0.06 * Double(indexPath.row)
            UIView.animate(withDuration: 0.8, delay: delay , usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell.layer.opacity = 1
            })
            
            animatedCellIndexPath.append(indexPath)
            didAnimateCellEntry = true
        }
    }
    
}
