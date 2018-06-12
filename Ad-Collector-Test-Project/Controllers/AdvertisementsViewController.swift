//
//  AdvertisementsViewController.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import CoreData
import Reachability

final class AdvertisementsViewController: UIViewController {
    
    //---- Properties ----//
    
    let viewModel = AdvertisementViewModel(adService: AdvertisementService(), likeService: LikeService())
    
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let reachabiltyHelper = ReachabilityHelper()
    private let refreshControl = UIRefreshControl()

    //---- Subivews ----//
    
    @IBOutlet weak var collectionView: AdvertisementCollectionView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    //---- VC Lifecycle ----//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityView()
        configureCollectionView()
        configureDataSource()
        configureReachability()
        
        UIAlertController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadCachedAdvertisements()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachabiltyHelper.stopMonitoring()
    }
    
    //---- Data Source ----//
    
    private func configureDataSource() {
        viewModel.delegate = self
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
        if viewModel.isDisplayingFavorites {
            viewModel.fetchFavoriteAdvertisements()
        } else {
            viewModel.loadAdvertisements()
        }
    }
    
    //---- Switch ----//
    
    @IBAction func didToggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            viewModel.isDisplayingFavorites = true
            viewModel.fetchFavoriteAdvertisements()
        } else {
            viewModel.isDisplayingFavorites = false
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
        
        if viewModel.isDisplayingFavorites && viewModel.likedAdvertisementIsEmpty {
            collectionView.setEmptyMessage()
        } else {
            collectionView.restore()
        }
        
        if viewModel.isDisplayingFavorites {
            return viewModel.favoriteAdvertisementCount
        } else {
            return viewModel.advertisementCount
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var advertisement: Advertisement
        
        // TODO: Check if you need two arrays
        if viewModel.isDisplayingFavorites {
            advertisement = viewModel.likedAdvertisement(atIndex: indexPath.row)
        } else {
            advertisement = viewModel.advertisement(atIndex: indexPath.row)
        }
        
        let cell: AdvertisementCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.configure(advertisement)
        
        return cell
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

extension AdvertisementsViewController: AdvertisementViewModelDelegate {
    
    func refresh() {
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
            if self.activityView.isAnimating {
                self.activityView.stopAnimating()
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func showError(message: ErrorType) {
        UIAlertController.show(from: self, errorType: message)
    }
    
}

extension AdvertisementsViewController: NSFetchedResultsControllerDelegate {
    
    
    
}

extension AdvertisementsViewController: Likeable {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: AdvertisementCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        viewModel.updateLikeStatus(forItemAt: indexPath)
    }
    
}

extension AdvertisementsViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        switch status {
        case .none:
            UIAlertController.show(from: self, errorType: .networkNotConnected)
        case .cellular, .wifi:
            break
        }
    }
    
}

extension AdvertisementsViewController: ErrorDisplayable {
    
    func hide() {
        dismiss(animated: true, completion: nil)
    }
    
}
