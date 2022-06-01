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
    
    func loadBanner(bannerURL: String){
        carrouselImage.kf.setImage(with: URL(string: bannerURL))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
