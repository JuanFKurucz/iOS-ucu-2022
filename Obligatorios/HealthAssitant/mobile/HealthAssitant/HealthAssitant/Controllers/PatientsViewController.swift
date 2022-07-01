//
//  PatientsViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 22/6/22.
//

import UIKit

class PatientsViewController: UIViewController {
    static let identifier : String = "PatientsViewController"
    @IBOutlet weak var patientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.patientsTableView.delegate = self
        self.patientsTableView.dataSource = self
        
        
        self.patientsTableView.register(UINib(nibName: PatientTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PatientTableViewCell.identifier)
    }

    @IBAction func onTapNewPatient(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self, nextViewController: NewPatientViewController.identifier)
    }
}

extension PatientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PatientTableViewCell.identifier) as! PatientTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row at \(indexPath.row)")
        let patientProfile = Navigation.jumpToView(currentViewController: self, nextViewController: "PatientProfileViewController") as! PatientProfileViewController
        
        let isoDate = "1999-02-20T00:00:00+0000"

        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDate)!
        patientProfile.patient = PatientModel(identification: "50550453", fullName: "Juan Francisco Kurucz", gender: Gender.male, birthDate:date)
    }
}
