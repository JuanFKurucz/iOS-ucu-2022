//
//  Alert.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 10/5/22.
//

import Foundation

import UIKit


class Alert {
    static func showAlertBox(currentViewController: UIViewController, title: String, message: String){

        let alert = UIAlertController(title: "Error", message: "Usuario o contraseña incorrecto", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        currentViewController.present(alert, animated: true, completion: nil)
    }
    
}
