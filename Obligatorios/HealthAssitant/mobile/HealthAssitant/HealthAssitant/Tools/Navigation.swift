//
//  Navigation.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 22/6/22.
//

import Foundation
import UIKit


class Navigation {
    /// This function shows another ViewController, which means it does the navigation
    ///
    /// - Parameter currentViewController: The current `UIViewController`
    /// - Parameter nextViewController: A stirng identifier for the next `UIViewController`
    /// - Returns  `UIViewController`: The next `UIViewController`
    static func jumpToView(currentViewController:UIViewController,nextViewController: String,overCurrntContext: Bool=false) -> UIViewController{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier:nextViewController)
        if(overCurrntContext){
            nextViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            currentViewController.present(nextViewController, animated: true)
        } else {
            currentViewController.show(nextViewController, sender: nil)
        }
        return nextViewController
    }
}
