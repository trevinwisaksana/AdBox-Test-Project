//
//  Ad_Collector_Test_ProjectTests.swift
//  Ad-Collector-Test-ProjectTests
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import XCTest
@testable import Ad_Collector_Test_Project

class Ad_Collector_Test_ProjectTests: XCTestCase {
    
    // MARK: - View Model
    
    var advertisementViewModel: AdvertisementViewModel!
    
    // MARK: - Dummy Services
    
    var dummyDataFactory = DummyDataFactory()
    
    var dummyAdvertisementService: DummyAdvertisementService!
    var dummyLikeService: LikeService!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //---- Advertisement View Model ----//
    
    func test_fetch_advertisement_data_success() {
        dummyAdvertisementService = DummyAdvertisementService(data: dummyDataFactory.dummyAdvertisements())
        dummyLikeService = LikeService()
        
        advertisementViewModel = AdvertisementViewModel(adService: dummyAdvertisementService, likeService: dummyLikeService)
        
        let expectation = XCTestExpectation(description: "Successfully loaded advertisement data.")
        
        advertisementViewModel.loadAdvertisements { (_) in
            XCTAssertFalse(self.advertisementViewModel.contentIsEmpty)
            XCTAssertEqual(self.advertisementViewModel.numberOfContents, 946)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetch_cached_advertisement_data_success() {
        dummyAdvertisementService = DummyAdvertisementService(data: dummyDataFactory.dummyAdvertisements())
        dummyLikeService = LikeService()
        
        advertisementViewModel = AdvertisementViewModel(adService: dummyAdvertisementService, likeService: dummyLikeService)
        
        let expectation = XCTestExpectation(description: "Successfully loaded cached advertisement data.")
        
        advertisementViewModel.loadCachedAdvertisements { (_) in
            XCTAssertFalse(self.advertisementViewModel.contentIsEmpty)
            XCTAssertEqual(self.advertisementViewModel.numberOfContents, 946)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}
