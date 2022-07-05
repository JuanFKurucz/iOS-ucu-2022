import Foundation
import UIKit

class Alert {
    static func showAlertBox(currentViewController: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        currentViewController.present(alert, animated: true, completion: nil)
    }

    static func showLoader(currentViewController: UIViewController, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        currentViewController.present(alert, animated: true, completion: completion)
    }

    static func hideLoader(currentViewController: UIViewController, completion: (() -> Void)? = nil) {
        currentViewController.dismiss(animated: false, completion: completion)
    }
}
