//
//  AdvertisementViewModel.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol AdvertisementViewModelDelegate: class {
    func refresh()
    func showError(message: ErrorType)
}

final class AdvertisementViewModel {
    
    // MARK: - Properties
    
    weak var delegate: AdvertisementViewModelDelegate?
    
    var advertisementService: AdvertisementService
    var likeService: LikeService
    
    var isDisplayingFavorites = false
    
    // MARK: - Core Data Properties
    
    private lazy var fetchResultsController: NSFetchedResultsController<Advertisement> = {
        let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: true)]
        fetchRequest.fetchBatchSize = 8

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    func setFetchResultControllerDelegate(with controller: NSFetchedResultsControllerDelegate) {
        self.fetchResultsController.delegate = controller
    }
    
    //---- Initializer ----//
    
    init(adService: AdvertisementService, likeService: LikeService) {
        self.advertisementService = adService
        self.likeService = likeService
    }
    
    //---- Advertisements ----//

    var advertisementIsEmpty: Bool {
        let fetchedObjects = fetchResultsController.fetchedObjects ?? [Advertisement]()
        return fetchedObjects.isEmpty
    }
  
    //---- Data Count ----//
    
    var numberOfAdvertisements: Int {
        return fetchResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    //---- Indexing ----//
    
    func advertisement(atIndexPath indexPath: IndexPath) -> Advertisement {
        return fetchResultsController.object(at: indexPath)
    }
    
    func delete(_ advertisement: Advertisement) {
        return fetchResultsController.managedObjectContext.delete(advertisement)
    }
    
    //---- Load Operation ----//
    
    func fetchAdvertisements(success: ((Bool) -> Void)?) {
        advertisementService.fetchAdvertisements { [unowned self] (advertisement, error)  in
            if let _ = error {
                self.delegate?.showError(message: .failedToFetchData)
            }
            
            success?(true)
        }
    }
    
    func loadCache(success: ((Bool) -> Void)?) {
        fetchResultsController.fetchRequest.predicate = nil

        do {
            try self.fetchResultsController.performFetch()
            success?(true)
        } catch {
            delegate?.showError(message: .failedToFetchData)
            success?(false)
        }
        
        let fetchedObjects = fetchResultsController.fetchedObjects ?? [Advertisement]()
        
        if fetchedObjects.isEmpty {
            fetchAdvertisements(success: success)
        }
    }
    
    //---- Like Service ----//
    
    func updateLikeStatus(forItemAt indexPath: IndexPath) {
        let adSelected = advertisement(atIndexPath: indexPath)
        adSelected.isLiked = !adSelected.isLiked
        
        do {
            try fetchResultsController.managedObjectContext.save()
        } catch {
            delegate?.showError(message: .failedToPerformLike)
        }
    }
    
    func fetchFavoriteAdvertisements() {
        let predicate = NSPredicate(format: "isLiked == YES")
        fetchResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            delegate?.showError(message: .failedToFetchData)
        }
    }
    
}
