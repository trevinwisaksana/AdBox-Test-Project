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
    
    let dataSource = AdvertisementViewModel(adService: AdvertisementService(), likeService: LikeService())
    
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let reachabiltyHelper = ReachabilityHelper()
    private let refreshControl = UIRefreshControl()
    private lazy var alertController = UIAlertController()
    
    //---- Subivews ----//
    
    @IBOutlet weak var collectionView: AdvertisementCollectionView!
    
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    private let emptyContentMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "There are currently no favorites."
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
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
        dataSource.loadAdvertisements()
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
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc
    private func reloadTimeline() {
        if dataSource.isDisplayingFavorites {
            dataSource.fetchLikedAdvertisements()
        } else {
            dataSource.loadAdvertisements()
        }
    }
    
    //---- Switch ----//
    
    @IBAction func didToggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            dataSource.isDisplayingFavorites = true
            dataSource.fetchLikedAdvertisements()
        } else {
            dataSource.isDisplayingFavorites = false
        }
        
        refresh()
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.isDisplayingFavorites {
            
            if dataSource.favoriteAdsIsEmpty {
                // TODO: This method is called many times, move this implementation
                let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
                emptyContentMessageLabel.frame = frame
                emptyContentMessageLabel.center = collectionView.center
                collectionView.backgroundView = emptyContentMessageLabel
            } else {
                collectionView.backgroundView = nil
            }
            
            return dataSource.numberOfFavoriteAds
            
        } else {
            collectionView.backgroundView = nil
            return dataSource.numberOfContents
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dataSource.isDisplayingFavorites {
            let favoriteAd = dataSource.favoriteAd(atIndex: indexPath.row)
            
            let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(favoriteAd)
            
            return cell
            
        } else {
            let advertisement = dataSource.contentData(atIndex: indexPath.row)
            
            let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(advertisement)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.45, height: collectionView.bounds.height * 0.36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.collectionView.animateCellEntry(for: cell, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }

}

extension AdvertisementsViewController: AdvertisementDataSourceDelegate {
    
    func refresh() {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        
        collectionView.reloadData()
    }
    
}

extension AdvertisementsViewController: Likeable {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: AdvertisementCell) {
        // TODO: Show spinner if loading or cancel the fetch request
//        likeButton.isUserInteractionEnabled = false
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
    
        dataSource.setLikeForAdvertisement(at: indexPath)
        
        if dataSource.isDisplayingFavorites {
            refresh()
        }
        
//        defer {
//            likeButton.isUserInteractionEnabled = true
//        }
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
