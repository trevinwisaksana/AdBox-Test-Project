//
//  UIAlertController+Displayable.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 12/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol ErrorDisplayable: class {
    func hide()
}

enum ErrorType {
    case failedToFetchData
    case networkNotConnected
}

extension UIAlertController {
    
    static weak var delegate: ErrorDisplayable?
    
    static func show(from viewController: UIViewController, errorType: ErrorType) {
        
        let alertController = UIAlertController()
        
        switch errorType {
        case .failedToFetchData:
            alertController.title = "Failed to retrieve data"
            alertController.message = "Please check your internet connection."
        case .networkNotConnected:
            alertController.title = "Network Error"
            alertController.message = "You are not connected to the internet."
        }
        
        viewController.present(alertController, animated: true, completion: {
            self.addTapGesture(on: alertController)
        })
    }
    
    static private func addTapGesture(on alertController: UIAlertController) {
        let selector = #selector(alertControllerTapGestureHandler(_:))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        
        let alertControllerSubview = alertController.view.superview?.subviews.first
        
        alertControllerSubview?.isUserInteractionEnabled = true
        alertControllerSubview?.addGestureRecognizer(tapGesture)
    }
    
    @objc
    static private func alertControllerTapGestureHandler(_ sender: UITapGestureRecognizer) {
        delegate?.hide()
    }
    
}
