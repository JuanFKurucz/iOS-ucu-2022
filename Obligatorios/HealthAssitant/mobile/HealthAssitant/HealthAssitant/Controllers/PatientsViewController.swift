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
    @IBOutlet weak var searchBarField: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    var patients : [PatientModel] = []
    var filterPatients : [PatientModel] = []
    
    var filterName : String? = nil
    var filterGender : Gender? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBarField.delegate = self
        self.patientsTableView.delegate = self
        self.patientsTableView.dataSource = self
        
        self.patientsTableView.register(UINib(nibName: PatientTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PatientTableViewCell.identifier)
    }
    
      func filterElements(name:String?, gender: Gender?) {
          self.filterName = name
          self.filterGender = gender
          
          if(self.filterName == nil || self.filterName!.count==0){
              if(self.filterGender != nil){
                  self.filterPatients = []
                  for patient in self.patients {
                      if(patient.gender == self.filterGender){
                          self.filterPatients.append(patient)
                      }
                  }
              } else {
                  self.filterPatients = self.patients
              }
          } else {
              self.filterPatients = []
              for patient in self.patients {
                  if(patient.getInformation().lowercased().contains(self.filterName!.lowercased())){
                      if(self.filterGender == nil || patient.gender == self.filterGender){
                          self.filterPatients.append(patient)
                      }
                  }
                  
              }
          }
          self.patientsTableView.reloadData()
      }
    
    @IBAction func onTapFilter(_ sender: Any) {
        let alertController = UIAlertController(title: "Filter patients", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "View all", style: .default, handler: {_ in
            self.filterGender = nil
            self.filterElements(name: self.filterName, gender: self.filterGender)
        }))
        alertController.addAction(UIAlertAction(title: "View male patients", style: .default, handler: {_ in
            self.filterGender = Gender.male
            self.filterElements(name: self.filterName, gender: self.filterGender)
        }))
        alertController.addAction(UIAlertAction(title: "View female patients", style: .default, handler: {_ in
            self.filterGender = Gender.female
            self.filterElements(name: self.filterName, gender: self.filterGender)
        }))
        alertController.addAction(UIAlertAction(title: "Filter", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIHealthAssitant.getPatients(onComplete: { p in
            self.patients = p
            self.filterPatients = p
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
        self.filterPatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PatientTableViewCell.identifier) as! PatientTableViewCell
        let patient = self.filterPatients[indexPath.row]
        cell.nameLabel.text = "\(patient.identification) - \(patient.fullName)"
        if let decodedImage = ImageUtils.base64ToImage(base64: patient.imageBase64) {
            cell.profileImageView.image = decodedImage
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patientProfile = Navigation.jumpToView(currentViewController: self, nextViewController: "PatientProfileViewController") as! PatientProfileViewController
        patientProfile.patient = self.filterPatients[indexPath.row]
    }
}


extension PatientsViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterName = searchText
        self.filterElements(name: self.filterName, gender: self.filterGender)
    }
}
