//
//  LoginViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 8/5/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    static let identifier = "LoginViewController"
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "userToken") {
            let _ = Navigation.jumpToView(currentViewController: self,nextViewController: MainViewController.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Visual.addNavBarImage(element:self)
    }
    
    func onLoginSuccess(user: AuthUser){
        let _ = Navigation.jumpToView(currentViewController: self,nextViewController: MainViewController.identifier)
    }
    
    func onLoginError(error: Error){
        Alert.showAlertBox(currentViewController: self, title: "Api error", message: error.localizedDescription)
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        if(emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true){
            Alert.showAlertBox(currentViewController: self,title: "Error",message: "Usuario o contraseña incorrecto")
        } else {
            APIPenca.login(email: emailTextField.text!, password: passwordTextField.text!, onComplete: self.onLoginSuccess, onFail: self.onLoginError)
        }
    }
    
    @IBAction func tapSignupButton(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self,nextViewController: SignupViewController.identifier)
    }
    
}
