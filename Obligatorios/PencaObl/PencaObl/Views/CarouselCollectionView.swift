//
//  CarouselCollectionView.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class CarouselCollectionView: UICollectionView {
    var bannerList : [UIImage?] = []
    
    func onAPIRequestFail(error: Error){
        print(error)
    }
    
    func onGetBannerURLsComplete(apiBanners: APIBanners){
        for imageURL in apiBanners.bannerURLs {
            self.bannerList.append(Visual.loadExternalImage(imageURL:  "https://\(imageURL)"))
        }
        self.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource=self
        
        APIPenca.getBannerURLs(onComplete: onGetBannerURLsComplete, onFail: onAPIRequestFail)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 193)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        self.collectionViewLayout = flowLayout
        
        self.register(UINib(nibName: CarouselCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
    }

}

extension CarouselCollectionView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.bannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell;
        cell.loadBanner(bannerImage:self.bannerList[indexPath.row])
        return cell;
    }
}
