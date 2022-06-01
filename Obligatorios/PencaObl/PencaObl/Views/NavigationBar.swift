//
//  NavigationBar.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 7/5/22.
//

import UIKit

class NavigationBar: UINavigationBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
    }
}
