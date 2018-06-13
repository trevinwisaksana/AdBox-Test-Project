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
    
    private var advertisementService: AdvertisementService
    
    var isDisplayingFavorites = false
    
    // MARK: - Core Data Properties
    
    lazy var fetchResultsController: NSFetchedResultsController<Advertisement> = {
        let fetchRequest = NSFetchRequest<Advertisement>(entityName: Constants.Entity.advertisement)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        fetchRequest.fetchBatchSize = 8

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    func setFetchResultControllerDelegate(with controller: NSFetchedResultsControllerDelegate) {
        self.fetchResultsController.delegate = controller
    }
    
    // MARK: - Advertisement Properties

    var advertisementIsEmpty: Bool {
        let fetchedObjects = fetchResultsController.fetchedObjects ?? [Advertisement]()
        return fetchedObjects.isEmpty
    }
    
    var numberOfAdvertisements: Int {
        return fetchResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    // MARK: - Initializer
    
    init(adService: AdvertisementService) {
        self.advertisementService = adService
    }
    
    // MARK: - Indexing
    
    func advertisement(atIndexPath indexPath: IndexPath) -> Advertisement {
        return fetchResultsController.object(at: indexPath)
    }
    
    // MARK: - Load Operation
    
    func fetchAdvertisements(success: ((Bool) -> Void)?) {
        advertisementService.fetchAdvertisements { [unowned self] (isSuccessful) in
            if !isSuccessful {
                self.delegate?.showError(message: .failedToFetchData)
                success?(false)
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
    
    // MARK: - Like
    
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
