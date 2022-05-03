//
//  SecondPageViewController.swift
//  NavigationApp
//
//  Created by Juan Francisco Kurucz on 21/4/22.
//

import UIKit

class SecondPageViewController: UIViewController {
    
    static let id: String = "SecondPageViewController"

    @IBOutlet weak var counterLabel: UILabel!
    
    var counter: Int = 0;
    
    public func getCounter() -> Int {
        return counter;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        counterLabel.text = "\(counter)"
    }
    
    @IBAction func nextPageButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        var nextViewController:UIViewController
        if counter >= 5 {
            nextViewController = storyBoard.instantiateViewController(withIdentifier: ModalPageViewController.id) as! ModalPageViewController
        } else {
            nextViewController = storyBoard.instantiateViewController(withIdentifier: ThirdPageViewController.id) as! ThirdPageViewController
        }
        show(nextViewController, sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        counter+=1
        counterLabel.text = "\(counter)"
    }

}
