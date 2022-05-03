//
//  ViewController.swift
//  NavigationApp
//
//  Created by Juan Francisco Kurucz on 21/4/22.
//

import UIKit

class ViewController: UIViewController {
    static let id: String = "ViewController"

    @IBOutlet weak var buttonNextPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func touchButtonNextPage(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: SecondPageViewController.id) as! SecondPageViewController
        show(nextViewController, sender: nil)
    }
    

}

