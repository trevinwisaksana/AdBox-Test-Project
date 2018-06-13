//
//  DummyFetchResultsControllerSuccess.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 13/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import CoreData

@testable import Ad_Collector_Test_Project

class DummyFetchResultsControllerSuccess: NSFetchedResultsController<Advertisement> {
    
    private var dummyDataFactorySuccess = DummyDataFactorySuccess()
    
    override var fetchRequest: NSFetchRequest<Advertisement> {
        return nil
    }
    
}
