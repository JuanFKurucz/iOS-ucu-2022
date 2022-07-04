import UIKit

class SignUpViewController: UIViewController {
    static let identifier: String = "SignUpViewController"
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSignUp(_: Any) {
        if let email = emailField.text, let password = passwordField.text {
            APIHealthAssitant.signup(email: email, password: password, onComplete: { _ in _ = Navigation.jumpToView(currentViewController: self, nextViewController: "TabBarController") }, onFail: { _ in Alert.showAlertBox(currentViewController: self, title: "Invalid singup", message: "Invalid signup information") })
        }
    }

    @IBAction func onSignIn(_: Any) {
        _ = Navigation.jumpToView(currentViewController: self, nextViewController: "LoginViewController")
    }
}
