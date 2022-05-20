//
//  CarouselCollectionViewCell.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    static let identifier = "CarouselCollectionViewCell"
    
    @IBOutlet weak var carrouselImage: UIImageView!
    
    func loadBanner(bannerImage: UIImage?){
        if let image = bannerImage {
            carrouselImage.image = image
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
