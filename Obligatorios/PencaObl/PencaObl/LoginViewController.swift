//
//  LoginViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Visual.addNavBarImage(element:self)
    }
    

    @IBAction func tapLoginButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: MainViewController.identifier) as! MainViewController
        show(nextViewController, sender: nil)
    }
    
    @IBAction func tapSignupButton(_ sender: Any) {
    }

}
