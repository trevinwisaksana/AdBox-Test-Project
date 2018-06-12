//
//  ProgressView.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 12/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: class {
    func errorView(_ errorView: ErrorView, didRetry sender: UIButton)
}

protocol ErrorDisplayable {
    static func show<T: ErrorView>(fromViewController viewController: UIViewController, animated: Bool, completion: ((Bool) -> Swift.Void)?) -> T
    static func show<T: ErrorView>(fromView view: UIView, insets: UIEdgeInsets, animated: Bool, completion: ((Bool) -> Swift.Void)?) -> T
    func hide(animated: Bool, completion: ((Bool) -> Swift.Void)?)
}

final class ErrorView: UIView {
    
    // MARK: Properties
    weak var delegate: ErrorViewDelegate?
    var animationDuration = 0.3
    fileprivate(set) var isAnimating = false
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureView()
    }
    
    // MARK: - Private methods
    private func configureView() {
        self.alpha = 0
    }
    
    fileprivate func show(animated: Bool = true, completion: ((Bool) -> Swift.Void)? = nil) {
        self.superview?.bringSubview(toFront: self)
        if animated {
            UIView.animate(withDuration: self.animationDuration, animations: { self.alpha = 1 }, completion: completion)
        } else {
            self.alpha = 1
            completion?(true)
        }
    }
    
}
