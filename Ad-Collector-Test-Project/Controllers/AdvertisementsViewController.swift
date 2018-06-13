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
    
    // MARK: - Properties
    
    let viewModel = AdvertisementViewModel(adService: AdvertisementService(), likeService: LikeService())
    
    private let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private let reachabiltyHelper = ReachabilityHelper()
    private let refreshControl = UIRefreshControl()

    private var blockOperations = [BlockOperation]()
    
    // MARK: - Subviews
    
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
        
        viewModel.loadCache(success: { (_) in
            DispatchQueue.main.async {
                if self.activityView.isAnimating {
                    self.activityView.stopAnimating()
                }
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachabiltyHelper.stopMonitoring()
    }
    
    // MARK: - Data Source
    
    private func configureDataSource() {
        viewModel.delegate = self
        viewModel.setFetchResultControllerDelegate(with: self)
    }
    
    // MARK: - Reachability
    
    private func configureReachability() {
        reachabiltyHelper.startMonitoring()
        reachabiltyHelper.add(listener: self)
    }
    
    // MARK: - Collection View Configuration
    
    private func configureCollectionView() {
        collectionView.register(AdvertisementCell.self)
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc
    private func reloadTimeline() {
        if viewModel.isDisplayingFavorites {
            refreshControl.isEnabled = false
        } else {
            refreshControl.isEnabled = true
            viewModel.fetchAdvertisements(success: nil)
        }
        
        refresh()
    }
    
    // MARK: - Switch
    
    @IBAction func didToggleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            viewModel.isDisplayingFavorites = true
            viewModel.fetchFavoriteAdvertisements()
        } else {
            viewModel.isDisplayingFavorites = false
            viewModel.loadCache(success: nil)
        }
        
        refresh()
    }
    
    // MARK: - Activity View
    
    func configureActivityView() {
        view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
    
}

// MARK: - UICollectionView

extension AdvertisementsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel.isDisplayingFavorites && viewModel.advertisementIsEmpty {
            collectionView.setEmptyMessage()
        } else {
            collectionView.restore()
        }
        
        return viewModel.numberOfAdvertisements
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let advertisement = viewModel.advertisement(atIndexPath: indexPath)
        
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

// MARK: - AdvertisementViewModelDelegate

extension AdvertisementsViewController: AdvertisementViewModelDelegate {
    
    func refresh() {
        collectionView.reloadData()
    }
    
    func showError(message: ErrorType) {
        UIAlertController.show(from: self, errorType: message)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension AdvertisementsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            guard let newIndexPath = newIndexPath else {
                return
            }
            
            let operation = BlockOperation {
                self.collectionView.insertItems(at: [newIndexPath])
            }
            
            blockOperations.append(operation)
            
        case .delete:
            
            guard let indexPath = indexPath else {
                return
            }
            
            let operation = BlockOperation {
                self.collectionView.deleteItems(at: [indexPath])
            }
            
            blockOperations.append(operation)
            
        default:
            break
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            
            for operation in blockOperations {
                operation.start()
            }
            
        }, completion: { (_) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                
                if self.activityView.isAnimating {
                    self.activityView.stopAnimating()
                }
            }
        })
    }
    
}

// MARK: - Likable

extension AdvertisementsViewController: Likeable {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: AdvertisementCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        viewModel.updateLikeStatus(forItemAt: indexPath)
    }
    
}

// MARK: - Network Status Listener

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

// MARK: - Error Displayable

extension AdvertisementsViewController: ErrorDisplayable {
    
    func hide() {
        dismiss(animated: true, completion: nil)
    }
    
}
