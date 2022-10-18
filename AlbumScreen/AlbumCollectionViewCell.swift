//
//  AlbumCollectionViewCell.swift
//  AlbumScreen
//
//  Created by shyam-8423 on 17/10/22.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    static let identifer: String = "albumCollectionViewCell"

    @IBOutlet private weak var imageView: UIImageView!
    
    var image: UIImage? {
        return imageView.image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with image: UIImage) {
        self.imageView.image = image
    }

}
