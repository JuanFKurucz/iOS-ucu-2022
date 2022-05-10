//
//  SignupViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class SignupViewController: UIViewController {
    static let identifier = "SignupViewController"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Visual.addNavBarImage(element:self)
    }
    
    @IBAction func tapSignupButton(_ sender: Any) {
        if(emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true){
            Alert.showAlertBox(currentViewController: self,title: "Error",message: "Usuario o contraseña incorrecto")
        } else {
            let _ = Navigation.jumpToView(currentViewController: self,nextViewController: MainViewController.identifier)
        }
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self,nextViewController: LoginViewController.identifier)
    }
}
