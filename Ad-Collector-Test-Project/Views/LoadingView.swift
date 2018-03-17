//
//  LoadingView.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

enum LoadingState {
    case loading, error, empty, idle
}

final class LoadingView: UIView {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var reload: UIButton!

    var state: LoadingState = .idle {
        didSet {
            switch state {
            case .loading:
                isHidden = false
                reload.isHidden = true
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimating()
                loadingLabel.text = "Hunting down new posts..."

            case .error:
                isHidden = false
                reload.isHidden = false
                loadingIndicator.isHidden = true
                loadingIndicator.startAnimating()
                loadingLabel.text = "Something went wrong 😿"

            case .empty:
                isHidden = false
                reload.isHidden = false
                loadingIndicator.isHidden = true
                loadingIndicator.startAnimating()
                loadingLabel.text = "Nothing to show 😿"

            case .idle:
                isHidden = true
                loadingIndicator.stopAnimating()
            }
        }
    }

    @IBAction func toggleReloadButton(_ sender: UIView) {
        state = .loading
        // Delegate call
    }
}

