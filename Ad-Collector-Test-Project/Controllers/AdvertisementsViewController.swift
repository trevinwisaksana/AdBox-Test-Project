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
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc
    private func reloadTimeline() {
        dataSource.loadAdvertisements { (error) in
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    //---- Switch ----//
    
    @IBAction func didToggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            dataSource.switchToggleIsOn = true
            dataSource.fetchLikedAdvertisements()
        } else {
            dataSource.switchToggleIsOn = false
        }
        
        refresh()
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {}
    
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
        
        if dataSource.switchToggleIsOn {
            
            if dataSource.favoriteAdsIsEmpty {
                let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
                emptyContentMessageLabel.frame = frame
                emptyContentMessageLabel.center = collectionView.center
                collectionView.backgroundView = emptyContentMessageLabel
            } else {
                collectionView.backgroundView = nil
            }
            
            return dataSource.numberOfFavoriteAds
            
        } else {
            return dataSource.numberOfContents
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if dataSource.switchToggleIsOn {
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
        return CGSize(width: collectionView.bounds.width * 0.45, height: collectionView.bounds.height * 0.38)
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
        collectionView.reloadData()
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
        
        let adLiked = dataSource.contentData(atIndex: indexPath.row)
        
        if let favoritedAd = CoreDataHelper.fetchSelectedFavoriteAd(withKey: adLiked.key) {
            dataSource.removeLike(for: favoritedAd)
        } else {
            dataSource.likeAdvertisement(for: adLiked)
        }
        
        refresh()
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
