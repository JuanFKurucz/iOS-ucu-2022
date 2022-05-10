//
//  SignupViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class SignupViewController: UIViewController {
    static let identifier = "SignupViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Visual.addNavBarImage(element:self)
    }
    
    @IBAction func tapSignupButton(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self,nextViewController: MainViewController.identifier)
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self,nextViewController: LoginViewController.identifier)
    }
}
