//
//  AdvertisementCell.swift
//  Ad-Collector-Test-Project
//
//  Created by Trevin Wisaksana on 17/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SDWebImage

protocol Likeable: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: AdvertisementCell)
}

final class AdvertisementCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var priceLabelContainerView: UIView!
    
    weak var delegate: Likeable?
    private var adKey: String?
    
    func configure(_ advertisement: Advertisement) {
        likeButton.isSelected = advertisement.isLiked
        adKey = advertisement.key
        titleLabel.text = advertisement.title
        locationLabel.text = advertisement.location
        priceLabel.text = Int(advertisement.price).truncattedStyleString
        
        priceLabelContainerView.roundCorner(radius: 5)
        
        if let posterURL = advertisement.posterURL {
            configureImage(withURL: posterURL)
        }
        
        configureDoubleTapGesture()
    }
    
    private func configureImage(withURL url: String) {
        let imageURL = URL(string: "https://images.finncdn.no/dynamic/480x360c/\(url)")
        
        let placeholderImage = UIImage(named: Constants.Image.placeholderImage)
        photoImageView.sd_setImage(with: imageURL, placeholderImage: placeholderImage, options: .scaleDownLargeImages, completed: nil)
        
        photoContainerView.layer.cornerRadius = 5
    }
    
    @IBAction func didTapLikeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.didTapLikeButton(sender, on: self)
    }
    
    private func configureDoubleTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapPhotoImageView(_:)))
        tapGesture.numberOfTapsRequired = 2
        photoImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didDoubleTapPhotoImageView(_ sender: UITapGestureRecognizer) {
        likeButton.isSelected = !likeButton.isSelected
        delegate?.didTapLikeButton(UIButton(), on: self)
    }
    
}
