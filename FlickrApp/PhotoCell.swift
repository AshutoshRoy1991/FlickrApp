//
//  PhotoCell.swift
//  FlickrApp
//
//  Created by Ashutosh Roy on 23/08/20.
//  Copyright © 2020 Ashutosh Roy. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoNameLabel: UILabel!
    
    var imageURL: String? {
        didSet {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                photoImageView.kf.setImage(with: url)
            } else {
                photoImageView.image = nil
                photoImageView.kf.cancelDownloadTask()
            }
        }
    }
    
    var imageName: String? {
        didSet {
            photoNameLabel.text = imageName ?? ""
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageURL = nil
    }
}
