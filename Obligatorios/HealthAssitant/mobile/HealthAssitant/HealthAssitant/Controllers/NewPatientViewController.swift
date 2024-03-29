import UIKit

class NewPatientViewController: UIViewController, DropDownTableViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let identifier: String = "NewPatientViewController"
    @IBOutlet var genderButton: UIButton!

    @IBOutlet var identificationField: UITextField!
    @IBOutlet var fullNameField: UITextField!
    @IBOutlet var birthDatePicker: UIDatePicker!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var newImageButton: UIButton!

    var imagePicker = UIImagePickerController()

    var genderValue: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSelectGender(_: Any) {
        let dropDown = Navigation.jumpToView(currentViewController: self, nextViewController: "DropDownTableViewController", overCurrntContext: true) as! DropDownTableViewController
        dropDown.delegate = self
        dropDown.elements = Gender.allCases.map { $0.text }
        dropDown.titleLabel.text = "Select gender"
    }

    func getSelected(element: Int) {
        if element == 0 {
            genderValue = nil
            genderButton.setTitle("Select gender", for: .normal)
        } else {
            genderValue = element
            genderButton.setTitle(Gender.allCases[element].text, for: .normal)
        }
    }

    @IBAction func onSubmitPatient(_: Any) {
        if let code = identificationField.text, let fullName = fullNameField.text, let genderValue = self.genderValue, let gender = Gender(rawValue: genderValue), let image = profileImageView.image {
            
            let desiredSize = CGSize(width: 100, height: 100)
            UIGraphicsBeginImageContextWithOptions(desiredSize, false, 1.0)
            image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width:
            desiredSize.width, height: desiredSize.height)))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData: Data = resizedImage!.pngData()!
            
            Alert.showLoader(currentViewController: self, completion: {
                APIHealthAssitant.newPatient(code: code, fullName: fullName, gender: gender, birthDate: self.birthDatePicker.date, base64Image: imageData.base64EncodedString(), onComplete: { _ in
                    Alert.hideLoader(currentViewController: self, completion: {
                        _ = self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    })
                }, onFail: { _ in
                    Alert.hideLoader(currentViewController: self, completion: {
                        Alert.showAlertBox(currentViewController: self, title: "Invalid new patient", message: "Could not create new patient")
                    })
                })
            })
        } else {
            Alert.showAlertBox(currentViewController: self, title: "Invalid new patient", message: "All fields must be filled")
        }
    }

    @IBAction func onNewImage(_: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }

    public func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
