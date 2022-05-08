//
//  CarouselCollectionView.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class CarouselCollectionView: UICollectionView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate=self
        self.dataSource=self
        
        self.register(UINib(nibName: CarouselCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
    }

}

extension CarouselCollectionView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell;
        cell.backgroundColor=UIColor(
            red:   CGFloat(Float.random(in: 0..<1)),
            green: CGFloat(Float.random(in: 0..<1)),
            blue:  CGFloat(Float.random(in: 0..<1)),
            alpha: CGFloat(Float.random(in: 0.5..<1))
        );
        return cell;
    }
    
    
}
