//
//  Visual.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 7/5/22.
//

import Foundation
import UIKit


class Visual {
    static func addNavBarImage(element: UIViewController, hidesBackButton: Bool = true) {
        let titleView = UIView(frame: CGRect(x: element.navigationController!.navigationBar.frame.minX, y: element.navigationController!.navigationBar.frame.minY, width: element.navigationController!.navigationBar.frame.width, height:element.navigationController!.navigationBar.frame.height))
        
        let imageView = UIImageView(image:  UIImage(named: "logo"))
        let imageWidth = CGFloat(170)
        let imageHeight = CGFloat(30)
        imageView.frame = CGRect(x: (titleView.frame.width)/2-imageWidth/2, y: (titleView.frame.height)/2-imageHeight/2, width: imageWidth, height: imageHeight)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        element.navigationItem.titleView = titleView
        if hidesBackButton {
            element.navigationItem.hidesBackButton = true
        }
    }
    
    static func loadExternalImage(imageURL: String) -> UIImage? {
        let url = URL(string: imageURL)
        let data = try? Data(contentsOf: url!)
        if let existentData = data {
            return UIImage(data: existentData)
        }
        return nil
    }
}
