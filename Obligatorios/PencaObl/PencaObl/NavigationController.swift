//
//  NavigationController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 28/4/22.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.backgroundColor = UIColor(red:22.0/255.0,green:27.0/255.0,blue:40.0/255.0, alpha:1.0)
        let image = UIImage(named: "navbar-mobile")
        let imageView = UIImageView(image:image)
        
        let bannerWidth = self.navigationBar.frame.size.width
        let bannerHeight = self.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        
        self.navigationItem.titleView = imageView
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
