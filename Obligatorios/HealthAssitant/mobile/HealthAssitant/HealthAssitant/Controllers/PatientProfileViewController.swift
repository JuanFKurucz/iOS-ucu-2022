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
    @IBOutlet weak var casesTableView: UITableView!
    var patient: PatientModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let patient = patient {
            fullNameLabel.text = patient.fullName
            idLabel.text = "ID : \(patient.identification)"
            genderLabel.text = "Gender: \(patient.gender.text)"
            
            if let birthDate = patient.birthDate {
                birthDateLabel.text = "Birth date: \(TextManipulation.dateToText(date: birthDate))"
            }
            
            self.casesTableView.delegate = self
            self.casesTableView.dataSource = self
            
            self.casesTableView.register(UINib(nibName: CaseTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CaseTableViewCell.identifier)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let patient = patient {
            APIHealthAssitant.getCases(patientId: patient.patientId, onComplete: { p in
                patient.cases = p
                self.casesTableView.reloadData()
            }, onFail: {_ in
                Alert.showAlertBox(currentViewController: self, title: "Invalid get cases", message: "Could not retrieve cases")
            })
        }
    }
    
    @IBAction func onTapNewCase(_ sender: Any) {
        let caseView = Navigation.jumpToView(currentViewController: self, nextViewController: "CaseViewController") as! CaseViewController
        if let patient = patient {
            APIHealthAssitant.getOrCreateCase(patientId: patient.patientId, onComplete: { caseElement in caseView.caseElement = caseElement
                caseView.onGetCase()
            }, onFail: {_ in
                Alert.showAlertBox(currentViewController: self, title: "Invalid retrieve or create case", message: "Could not get or retrieve case")
            })
            
        }
    }
}


extension PatientProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.patient!.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CaseTableViewCell.identifier) as! CaseTableViewCell
        let caseElement = self.patient!.cases[indexPath.row]
        cell.caseName.text = "\(caseElement.getName())"
        return cell
    }
}
