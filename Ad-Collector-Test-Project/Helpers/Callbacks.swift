//
//  Callbacks.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 04/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

typealias AdvertisementOperationClosure = ([Advertisement], Error?) -> Void
typealias FetchAdvertisementOperationClosure = (Advertisement?, Error?) -> Void
typealias SuccessOperationClosure = (Bool) -> Void
