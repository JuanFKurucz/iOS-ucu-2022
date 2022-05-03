//
//  ModalPageViewController.swift
//  NavigationApp
//
//  Created by Juan Francisco Kurucz on 21/4/22.
//

import UIKit

class ModalPageViewController: UIViewController {
    static let id: String = "ModalPageViewController"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchShowLast(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: ModalSecondPageViewController.id) as! ModalSecondPageViewController
        show(nextViewController, sender: nil)
    }
}
