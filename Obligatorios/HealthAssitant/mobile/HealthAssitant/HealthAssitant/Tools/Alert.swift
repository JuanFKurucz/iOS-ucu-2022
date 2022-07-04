import Foundation
import UIKit

class Alert {
    static func showAlertBox(currentViewController: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        currentViewController.present(alert, animated: true, completion: nil)
    }
}
