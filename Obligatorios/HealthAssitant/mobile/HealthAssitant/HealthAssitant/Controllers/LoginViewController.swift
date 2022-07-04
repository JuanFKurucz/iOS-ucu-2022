//
//  ViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 16/6/22.
//

import UIKit

class LoginViewController: UIViewController {
    static let identifier : String = "LoginViewController"
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSignIn(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            APIHealthAssitant.login(email: email, password: password, onComplete: { _ in let _ = Navigation.jumpToView(currentViewController: self, nextViewController: "TabBarController")}, onFail: {_ in
                Alert.showAlertBox(currentViewController: self, title: "Invalid login", message: "Invalid login information")
            })
        }
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self, nextViewController: "SignUpViewController")
    }
    
}

