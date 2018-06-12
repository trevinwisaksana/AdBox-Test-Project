//
//  ErrorView+ErrorDisplayable.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 12/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

//extension ErrorView: ErrorDisplayable {
//
//    static func show<T>(fromViewController viewController: UIViewController, animated: Bool, completion: ((Bool) -> Void)?) -> T where T : ErrorView {
//        guard let subview = loadFromNib() as? T else {
//            fatalError("The subview is expected to be of type \(T.self)")
//        }
//
//        viewController.view.addSubview(subview)
//
//        subview.alpha = 0
//        subview.superview?.sendSubview(toBack: subview)
//        subview.show(animated: animated) { finished in
//            if finished {
//                subview.playAnimation()
//            }
//        }
//
//        return subview
//    }
//
//    static func show<T>(fromView view: UIView, insets: UIEdgeInsets, animated: Bool, completion: ((Bool) -> Void)?) -> T where T : ErrorView {
//
//        guard let subview = loadFromNib() as? T else {
//            fatalError("The subview is expected to be of type \(T.self)")
//        }
//
//        view.addSubview(subview)
//
//        // Configure constraints if needed
//
//        subview.alpha = 0
//        subview.superview?.sendSubview(toBack: subview)
//        subview.show(animated: animated) { finished in
//            if finished {
//                subview.playAnimation()
//            }
//        }
//        return subview
//
//    }
//
//    func hide(animated: Bool, completion: ((Bool) -> Void)?) {
//
//        let closure: (Bool) -> Void = { (finished) in
//            if finished {
//                self.removeFromSuperview()
//            }
//        }
//        if animated {
//            UIView.animate(withDuration: self.animationDuration, delay: 0.25, animations: { self.alpha = 0 }, completion: { (finished) in closure(finished)
//            })
//        } else {
//            self.alpha = 0
//            closure(true)
//            completion?(true)
//        }
//    }
//
//}
