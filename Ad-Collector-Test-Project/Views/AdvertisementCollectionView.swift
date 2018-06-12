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
    
    //---- Animation ----//
    
    func animateCellEntry(for cell: UICollectionViewCell, at indexPath: IndexPath) {
        if !animatedCellIndexPath.contains(indexPath) {
            
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            cell.layer.opacity = 0.0
            
            let delay = 0.03 * Double(indexPath.row)
            UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                cell.layer.opacity = 1
            })
            
            animatedCellIndexPath.append(indexPath)
        }
    }
    
}
