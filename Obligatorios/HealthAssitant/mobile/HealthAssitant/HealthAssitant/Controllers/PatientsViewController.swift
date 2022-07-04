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
    
    var patients : [PatientModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.patientsTableView.delegate = self
        self.patientsTableView.dataSource = self
        
        self.patientsTableView.register(UINib(nibName: PatientTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PatientTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIHealthAssitant.getPatients(onComplete: { p in
            self.patients = p
            self.patientsTableView.reloadData()
        }, onFail: {_ in
            Alert.showAlertBox(currentViewController: self, title: "Invalid retrieve patients", message: "Could not retrieve patients")
        })
    }

    @IBAction func onTapNewPatient(_ sender: Any) {
        let _ = Navigation.jumpToView(currentViewController: self, nextViewController: NewPatientViewController.identifier)
    }
}

extension PatientsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PatientTableViewCell.identifier) as! PatientTableViewCell
        let patient = self.patients[indexPath.row]
        cell.nameLabel.text = "\(patient.identification) - \(patient.fullName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patientProfile = Navigation.jumpToView(currentViewController: self, nextViewController: "PatientProfileViewController") as! PatientProfileViewController
        patientProfile.patient = self.patients[indexPath.row]
    }
}
