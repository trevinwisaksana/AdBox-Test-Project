//
//  LikeService.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

protocol LikeServiceProtocol: class {
     func setLike(status isLiked: Bool, for advertisement: Advertisement, success: @escaping SuccessOperationClosure)
    func like(_ advertisement: Advertisement, success: @escaping SuccessOperationClosure)
    func unlike(_ advertisement: Advertisement, success: @escaping SuccessOperationClosure)
}

class LikeService: LikeServiceProtocol {
    
    var coreDataStack = CoreDataStack()
    
    func setLike(status isLiked: Bool, for advertisement: Advertisement, success: @escaping SuccessOperationClosure) {
        if isLiked {
            unlike(advertisement, success: success)
        } else {
            like(advertisement, success: success)
        }
    }
    
    func like(_ advertisement: Advertisement, success: @escaping SuccessOperationClosure) {
        coreDataStack.addLiked(advertisement, success: success)
    }
    
    func unlike(_ advertisement: Advertisement, success: @escaping SuccessOperationClosure) {
        coreDataStack.dislike(advertisement, success: success)
    }
    
}
