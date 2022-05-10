//
//  LoginViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class LoginViewController: UIViewController {

    static let identifier = "LoginViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Visual.addNavBarImage(element:self)
    }
    

    @IBAction func tapLoginButton(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self,nextViewController: MainViewController.identifier)
    }
    
    @IBAction func tapSignupButton(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self,nextViewController: SignupViewController.identifier)
    }

}
