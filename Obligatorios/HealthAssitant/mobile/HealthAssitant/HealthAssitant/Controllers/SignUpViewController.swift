//
//  SignUpViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 16/6/22.
//

import UIKit

class SignUpViewController: UIViewController {
    static let identifier : String = "SignUpViewController"
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onSignUp(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            APIHealthAssitant.signup(email: email, password: password, onComplete: { _ in let _ = Navigation.jumpToView(currentViewController: self, nextViewController: "TabBarController")}, onFail: {_ in Alert.showAlertBox(currentViewController: self, title: "Invalid singup", message: "Invalid signup information")})
        }
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self, nextViewController: "LoginViewController")
    }
    
}
