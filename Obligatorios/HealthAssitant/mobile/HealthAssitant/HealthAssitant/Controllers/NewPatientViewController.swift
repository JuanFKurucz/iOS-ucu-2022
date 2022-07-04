//
//  NewPatientViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 22/6/22.
//

import UIKit

class NewPatientViewController: UIViewController, DropDownTableViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let identifier : String = "NewPatientViewController"
    @IBOutlet weak var genderButton: UIButton!
    
    @IBOutlet weak var identificationField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var newImageButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var genderValue : Int = -1
    var genderOptions : [String] = ["Male","Female"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSelectGender(_ sender: Any) {
        let dropDown = Navigation.jumpToView(currentViewController: self, nextViewController: "DropDownTableViewController",overCurrntContext: true) as! DropDownTableViewController
        dropDown.delegate = self
        dropDown.elements = self.genderOptions
        dropDown.titleLabel.text = "Select gender"
    }
    
    func getSelected(element: Int) {
        if element >= genderOptions.count {
            self.genderValue = -1
            self.genderButton.setTitle("Select gender", for:.normal)
        } else {
            self.genderValue = element
            self.genderButton.setTitle(self.genderOptions[element], for:.normal)
        }
    }
    
    @IBAction func onSubmitPatient(_ sender: Any) {
        if let code = identificationField.text, let fullName = fullNameField.text, let gender = Gender(rawValue: genderValue+1), let image = profileImageView.image {
            let imageData:Data = image.pngData()!
            APIHealthAssitant.newPatient(code: code, fullName: fullName, gender: gender, birthDate: birthDatePicker.date, base64Image:imageData.base64EncodedString(), onComplete: { _ in let _ = self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil) }, onFail: {_ in Alert.showAlertBox(currentViewController: self, title: "Invalid new patient", message: "Could not create new patient")})
        } else {
            Alert.showAlertBox(currentViewController: self, title: "Invalid new patient", message: "All fields must be filled")
        }
    }
    
    @IBAction func onNewImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
           imagePicker.delegate = self
           imagePicker.sourceType = .savedPhotosAlbum
           imagePicker.allowsEditing = false
           present(imagePicker, animated: true, completion: nil)
       }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}
