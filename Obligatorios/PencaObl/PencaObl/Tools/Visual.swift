//
//  Visual.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 7/5/22.
//
import Foundation
import UIKit


class Visual {
    static func addNavBarImage(element: UIViewController, hidesBackButton: Bool = true, showsLogout: Bool = false) {
        let titleView = UIView(frame: CGRect(x: element.navigationController!.navigationBar.frame.minX, y: element.navigationController!.navigationBar.frame.minY, width: element.navigationController!.navigationBar.frame.width, height:element.navigationController!.navigationBar.frame.height))
        
        let imageView = UIImageView(image:  UIImage(named: "logo"))
        let imageWidth = CGFloat(170)
        let imageHeight = CGFloat(30)
        imageView.frame = CGRect(x: (titleView.frame.width)/2-imageWidth/2, y: (titleView.frame.height)/2-imageHeight/2, width: imageWidth, height: imageHeight)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        titleView.addSubview(imageView)
        titleView.backgroundColor = .clear
        element.navigationItem.titleView = titleView
        
        if hidesBackButton {
            element.navigationItem.hidesBackButton = true
        }
        if showsLogout{
            let rightNavButton: UIBarButtonItem = UIBarButtonItem(title: "Logout", image: nil, primaryAction: UIAction { _ in Visual.logout(element:element) }, menu: nil)
            element.navigationItem.rightBarButtonItem = rightNavButton
        }
    }
    
    static func logout(element: UIViewController)
    {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "userToken")
        let _ = Navigation.jumpToView(currentViewController: element, nextViewController: LoginViewController.identifier)
    }
}
