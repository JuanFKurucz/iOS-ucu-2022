//
//  NewPatientViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 22/6/22.
//

import UIKit

class NewPatientViewController: UIViewController, DropDownTableViewControllerDelegate {
    static let identifier : String = "NewPatientViewController"
    @IBOutlet weak var genderButton: UIButton!
    
    @IBOutlet weak var identificationField: UITextField!
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
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
        if let code = identificationField.text, let fullName = fullNameField.text, let gender = Gender(rawValue: genderValue+1) {
            APIHealthAssitant.newPatient(code: code, fullName: fullName, gender: gender, birthDate: birthDatePicker.date, onComplete: { _ in let _ = self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil) }, onFail: {_ in print("error")})
        } else {
            print("not all fields filled")
        }
        
    }
}
