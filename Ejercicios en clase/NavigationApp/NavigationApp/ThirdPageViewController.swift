//
//  ThirdPageViewController.swift
//  NavigationApp
//
//  Created by Juan Francisco Kurucz on 21/4/22.
//

import UIKit

class ThirdPageViewController: UIViewController {
    
    static let id: String = "ThirdPageViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchGoBackButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
}
