//
//  DisplaySectionViewController.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 18/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class DisplaySectionViewController: UIViewController {
    
    //---- Properties ----//
    
    let dataSource = DisplaySectionViewModel(service: LikeService())
    
    //---- Subviews ----//
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //---- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    //---- IBAction ----//
    
    @IBAction func didTapDoneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //---- Data Source ----//
    
    private func configureDataSource() {
        dataSource.delegate = self
    }
    
    //---- Collection View ----//
    
    private func configureCollectionView() {
        collectionView.register(AdvertisementCell.self)
        configureCollectionViewLayout()
    }
    
    private func configureCollectionViewLayout() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 205, height: 260)
            flowLayout.headerReferenceSize = CGSize(width: 50, height: 60)
            flowLayout.footerReferenceSize = CGSize(width: 50, height: 50)
            flowLayout.minimumLineSpacing = 0
        }
    }
    
    //---- Miscellaneous ----//
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension DisplaySectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionAd = dataSource.data(atIndex: indexPath.row)
        
        let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.configure(sectionAd)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let sectionHeader: DisplaySectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            
            sectionHeader.titleLabel.text = dataSource.determineSectionTitle()
            
            return sectionHeader
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension DisplaySectionViewController: AdvertisementDataSourceDelegate {
    
    func contentChange() {
        collectionView.reloadData()
    }
    
}

extension DisplaySectionViewController: Likeable {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: AdvertisementCell) {
        
        defer {
            likeButton.isUserInteractionEnabled = true
        }
        
        likeButton.isUserInteractionEnabled = false
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        let adLiked = dataSource.data(atIndex: indexPath.row)
        
        if let favoritedAd = CoreDataHelper.fetchSelectedFavoriteAd(withKey: adLiked.key) {
            dataSource.removeLike(for: favoritedAd)
        } else {
            dataSource.likeAdvertisement(for: adLiked)
        }
        
    }
    
}
