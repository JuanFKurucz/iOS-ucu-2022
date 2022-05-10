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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //let height = CGFloat(80)
        let height = navigationBar.frame.height
        navigationBar.frame = CGRect(x: view.safeAreaInsets.left, y: view.safeAreaInsets.top, width: view.frame.width, height: height)
    }
    
}
