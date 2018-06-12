//
//  Int+Commas.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 19/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension Int {
    
    var decimalStyleString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        return formattedNumber ?? String(self)
    }
    
    var truncattedStyleString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        if self >= 100000 {
            
            let value = numberFormatter.string(from: NSNumber(value: self / 1000)) ?? String(self)
            
            return "\(value)" + ",-"
        } else {
            let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
            return formattedNumber ?? String(self)
        }
        
    }
   
}
