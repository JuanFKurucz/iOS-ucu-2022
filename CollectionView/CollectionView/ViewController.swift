//
//  ViewController.swift
//  CollectionView
//
//  Created by Juan Francisco Kurucz on 20/4/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        collectionView.register(UINib(nibName: CollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell;
        
//        cell.delegate = self;
        
        cell.backgroundColor=UIColor(
            red:   CGFloat(Float.random(in: 0..<1)),
            green: CGFloat(Float.random(in: 0..<1)),
            blue:  CGFloat(Float.random(in: 0..<1)),
            alpha: CGFloat(Float.random(in: 0.5..<1))
        );
        return cell;
    }
    
    
}
