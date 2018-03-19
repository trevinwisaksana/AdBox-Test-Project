//
//  AdvertisementsViewController.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import Reachability

final class AdvertisementsViewController: UIViewController {
    
    //---- Properties ----//
    
    let dataSource = AdvertisementViewModel()
    
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let reachabiltyHelper = ReachabilityHelper()
    private let refreshControl = UIRefreshControl()
    private lazy var alertController = UIAlertController()
    
    //---- Subivews ----//
    
    @IBOutlet weak var collectionView: AdvertisementCollectionView!
    
    //---- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityView()
        configureCollectionView()
        configureDataSource()
        configureReachability()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadCachedAdvertisements { (_) in
            if self.activityView.isAnimating {
                self.activityView.stopAnimating()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachabiltyHelper.stopMonitoring()
    }
    
    //---- Data Source ----//
    
    private func configureDataSource() {
        dataSource.delegate = self
    }
    
    //---- Reachability ----//
    
    private func configureReachability() {
        reachabiltyHelper.startMonitoring()
        reachabiltyHelper.add(listener: self)
    }
    
    //---- Collection View ----//
    
    private func configureCollectionView() {
        collectionView.register(AdvertisementCell.self)
        configureCollectionViewLayout()
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    private func configureCollectionViewLayout() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 50, height: 100)
            flowLayout.headerReferenceSize = CGSize(width: 50, height: 60)
            flowLayout.footerReferenceSize = CGSize(width: 50, height: 50)
        }
    }
    
    @objc
    private func reloadTimeline() {
        dataSource.loadAdvertisements { (error) in
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    //---- Activity View ----//
    
    func configureActivityView() {
        view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
    
}

extension AdvertisementsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if dataSource.contentIsEmpty {
            return 0
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataSource.contentIsEmpty {
            return 0
        }
        
        switch section {
        case 0:
            return dataSource.numberOfPopularContent
        case 1:
            return dataSource.numberOfCarContent
        case 2:
            return dataSource.numberOfBapContent
        case 3:
            return dataSource.numberOfRealEstateContent
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        
        switch section {
        case 0:
            
            let popularAd = dataSource.mostPopularContentData(atIndex: indexPath.row)
            
            let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(popularAd)
            
            return cell
            
        case 1:
            
            let carAd = dataSource.carsContentData(atIndex: indexPath.row)
            
            let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(carAd)
            
            return cell
            
        case 2:
            
            let bapAd = dataSource.bapContentData(atIndex: indexPath.row)
            
            let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(bapAd)
            
            return cell
            
        case 3:
            
            let realEstateAd = dataSource.realEstateContentData(atIndex: indexPath.row)
            
            let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(realEstateAd)
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = indexPath.section
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let sectionHeader: AdvertisementsSectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            
            switch section {
            case 0:
                sectionHeader.titleLabel.text = "Trending"
            case 1:
                sectionHeader.titleLabel.text = "Cars"
            case 2:
                sectionHeader.titleLabel.text = "Books"
            case 3:
                sectionHeader.titleLabel.text = "Real Estate"
            default:
                fatalError("Error: unexpected indexPath.")
            }
            
            return sectionHeader
            
        case UICollectionElementKindSectionFooter:
            
            let sectionFooter: AdvertisementsSectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            sectionFooter.delegate = self
            sectionFooter.section = section
            
            return sectionFooter
            
        default:
            fatalError("Error: unexpected view kind.")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 0.0)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionView.animateCellEntry(for: cell, at: indexPath)
    }
    
}

extension AdvertisementsViewController: AdvertisementDataSourceDelegate {
    
    func contentChange() {
        collectionView.reloadData()
    }
    
}

extension AdvertisementsViewController: DisplayMoreAdsDelegate {
    
    func pass(section: Int) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.advertisements, bundle: .main)
        let displaySectionVC = storyboard.instantiateViewController(withIdentifier: Constants.Identifier.displayVC) as! DisplaySectionViewController
        
        let sectionData = dataSource.passData(fromSection: section)
        displaySectionVC.dataSource.loadContent(sectionData)
        
        present(displaySectionVC, animated: true, completion: nil)
    }
    
}

extension AdvertisementsViewController: Likeable {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: AdvertisementCell) {
        
        defer {
            likeButton.isUserInteractionEnabled = true
        }
        
        likeButton.isUserInteractionEnabled = false
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        var adLiked: Advertisement?
        
        switch indexPath.section {
        case 0:
            adLiked = dataSource.mostPopularContentData(atIndex: indexPath.row)
        case 1:
            adLiked = dataSource.carsContentData(atIndex: indexPath.row)
        case 2:
            adLiked = dataSource.bapContentData(atIndex: indexPath.row)
        case 3:
            adLiked = dataSource.realEstateContentData(atIndex: indexPath.row)
        default:
            break
        }
        
        if let key = adLiked?.key, let favoritedAd = CoreDataHelper.fetchSelectedFavoriteAd(withKey: key) {
            LikeService.remove(favoritedAd)
        } else {
            LikeService.saveToFavorite(adLiked)
        }
    }
    
}

extension AdvertisementsViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        switch status {
        case .none:
            displayErrorMessage()
        case .cellular, .wifi:
            break
        }
    }
    
    private func displayErrorMessage() {
        alertController.title = "Network Error"
        alertController.message = "You are not connected to the internet."
        
        present(alertController, animated: true) {
            self.addAlertControllerTapGesture()
        }
    }
    
    private func addAlertControllerTapGesture() {
        let selector = #selector(alertControllerTapGestureHandler)
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        let alertControllerSubview = alertController.view.superview?.subviews[1]
        alertControllerSubview?.isUserInteractionEnabled = true
        alertControllerSubview?.addGestureRecognizer(tapGesture)
    }
    
    @objc private func alertControllerTapGestureHandler() {
        dismiss(animated: true, completion: nil)
    }
    
}
