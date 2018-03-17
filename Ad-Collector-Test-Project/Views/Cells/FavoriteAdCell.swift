//
//  FavoriteAdCell.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SDWebImage

protocol Dislikeable: class {
    func didTapDislikeButton(_ dislikeButton: UIButton, on cell: FavoriteAdCell)
}

final class FavoriteAdCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    // TODO: Change name
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: Dislikeable?
    
    func configure(_ data: FavoriteAd) {
        descriptionLabel.text = data.title
        priceLabel.text = "kr \(data.price)"
        locationLabel.text = data.location
        likeButton.isSelected = data.isFavorite
        
        if let photoURL = data.photoURL {
            let imageURL = URL(string: "https://images.finncdn.no/dynamic/480x360c/\(photoURL)")
            photo.sd_setImage(with: imageURL, completed: nil)
            photo.layer.cornerRadius = 5
        }
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        delegate?.didTapDislikeButton(sender, on: self)
    }
    
}
