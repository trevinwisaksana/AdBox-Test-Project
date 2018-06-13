//
//  OperationTimer.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 13/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import CoreFoundation

/// Used to check the time of code execution.
struct OperationTimer {
    
    static var startTime: CFAbsoluteTime?
    static var endTime: CFAbsoluteTime?
    
    static func start() {
       startTime = CFAbsoluteTimeGetCurrent()
    }
    
    static func stop() -> String {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return "The task took \(duration!) seconds."
    }
    
    static var duration: CFAbsoluteTime? {
        if let endTime = endTime, let startTime = startTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
