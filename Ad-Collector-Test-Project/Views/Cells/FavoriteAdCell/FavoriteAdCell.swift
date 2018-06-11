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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: Dislikeable?
    
    func configure(_ data: FavoriteAd) {
        descriptionLabel.text = data.title
        priceLabel.text = "kr " + Int(data.price).decimalStyleString
        locationLabel.text = data.location
        likeButton.isSelected = data.isLiked
        
        if let posterURL = data.posterURL {
            let imageURL = URL(string: "https://images.finncdn.no/dynamic/480x360c/\(posterURL)")
            let placeholderImage = UIImage(named: Constants.Image.placeholderImage)
            photoImageView.sd_setImage(with: imageURL, placeholderImage: placeholderImage, options: .scaleDownLargeImages, completed: nil)
        }
        
        photoImageView.layer.cornerRadius = 5
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        delegate?.didTapDislikeButton(sender, on: self)
    }
    
}
