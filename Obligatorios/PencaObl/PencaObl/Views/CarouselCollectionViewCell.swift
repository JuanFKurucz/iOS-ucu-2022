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
        let url = URL(string: "https://\(bannerURL)")
        let data = try? Data(contentsOf: url!)
        if let existentData = data {
            carrouselImage.image = UIImage(data: existentData)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
