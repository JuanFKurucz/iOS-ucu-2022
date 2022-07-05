import UIKit

class LoginViewController: UIViewController {
    static let identifier: String = "LoginViewController"
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSignIn(_: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Alert.showLoader(currentViewController: self, completion: {
                APIHealthAssitant.login(email: email, password: password, onComplete: { _ in
                    Alert.hideLoader(currentViewController: self)
                    _ = Navigation.jumpToView(currentViewController: self, nextViewController: "TabBarController")
                }, onFail: { _ in
                    Alert.hideLoader(currentViewController: self, completion: {
                        Alert.showAlertBox(currentViewController: self, title: "Invalid login", message: "Invalid login information")
                    })
                })
            })
        }
    }

    @IBAction func onSignUp(_: Any) {
        _ = Navigation.jumpToView(currentViewController: self, nextViewController: "SignUpViewController")
    }
}
