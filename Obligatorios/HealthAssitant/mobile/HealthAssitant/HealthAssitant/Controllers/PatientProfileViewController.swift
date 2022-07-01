//
//  PatientProfileViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

import UIKit

class PatientProfileViewController: UIViewController {
    static let identifier : String = "PatientProfileViewController"

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    var patient: PatientModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let patient = patient {
            fullNameLabel.text = patient.fullName
            idLabel.text = "ID : \(patient.identification)"
            genderLabel.text = "Gender: \(patient.gender.text)"
            birthDateLabel.text = "Birth date: \(patient.birthDate.ISO8601Format())"
        }
    }
    
    @IBAction func onTapNewCase(_ sender: Any) {
        let caseView = Navigation.jumpToView(currentViewController: self, nextViewController: "CaseViewController") as! CaseViewController
        if let patient = patient {
            caseView.caseElement = patient.getOrCreateCurrentCase()
        }
    }
    
}
