//
//  CaseViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

import UIKit



protocol CaseViewControllerDelegate {
    func onTerminateCase()
}


class CaseViewController: UIViewController, DropDownTableViewControllerDelegate, CaseViewControllerDelegate {
    static let identifier : String = "CaseViewController"
    @IBOutlet weak var caseNameLabel: UILabel!
    @IBOutlet weak var diagnosticLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var informationTableView: UITableView!
    
    @IBOutlet weak var informationDropDown: UIButton!
    var caseElement : CaseModel?
    
    var informationValue: Symptom?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let caseElement = self.caseElement {
            caseNameLabel.text = caseElement.getName()
            
            
            self.informationTableView.delegate = self
            self.informationTableView.dataSource = self
            
            
            self.informationTableView.register(UINib(nibName: InformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InformationTableViewCell.identifier)
        }
    }
    
    func onTerminateCase() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func predictDiagnosis() -> Diagnosis {
        return Diagnosis.COVID19
    }
    
    func getSelected(element: Int) {
        if element >= Symptom.allCases.count {
            self.informationValue = nil
            self.informationDropDown.setTitle("Select information", for:.normal)
        } else {
            self.informationValue = Symptom.allCases[element]
            self.informationDropDown.setTitle(Symptom.allCases[element].rawValue, for:.normal)
        }
    }
    
    @IBAction func onInformationDropDown(_ sender: Any) {
        let dropDown = Navigation.jumpToView(currentViewController: self, nextViewController: "DropDownTableViewController",overCurrntContext: true) as! DropDownTableViewController
        dropDown.delegate = self
        dropDown.elements = Symptom.allCases.map({ $0.rawValue })
        dropDown.titleLabel.text = "Select information"
    }
    
    @IBAction func onSubmitInformation(_ sender: Any) {
        if let symptom = self.informationValue {
            self.caseElement?.addInformation(symptom: symptom, date: nil)
            
            self.diagnosticLabel.text = "Possible diagnostic: \(self.predictDiagnosis().rawValue)"
            
            self.informationValue = nil
            self.informationDropDown.setTitle("Select information", for:.normal)
            
            self.informationTableView.reloadData()
        }
    }
    
    @IBAction func onCloseCase(_ sender: Any) {
        let closeCaseView = Navigation.jumpToView(currentViewController: self, nextViewController: "CloseCaseViewController") as! CloseCaseViewController
        closeCaseView.caseElement = caseElement
        closeCaseView.delegate = self
    }
}

extension CaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.caseElement!.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier) as! InformationTableViewCell
        let information = self.caseElement!.history[indexPath.row]
        cell.informationLabel.text = "\(information.date.ISO8601Format()) - \(information.symptom.rawValue)"
        return cell
    }
}

