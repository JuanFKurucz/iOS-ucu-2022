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

        self.informationTableView.delegate = self
        self.informationTableView.dataSource = self
        
        self.informationTableView.register(UINib(nibName: InformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InformationTableViewCell.identifier)
    }
    
    func onGetCase() {
        if let caseElement = self.caseElement {
            caseNameLabel.text = caseElement.getName()
            self.informationTableView.reloadData()
        }
    }
    
    func onTerminateCase() {
        if let caseElement = caseElement {
            APIHealthAssitant.closeCase(patientId: caseElement.patientId, caseId: caseElement.caseId, diagnostic: caseElement.diagnosis!, date: caseElement.endDate!, onComplete: {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }, onFail: {_ in print("error")})
        }
        
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
            self.informationDropDown.setTitle(Symptom.allCases[element].text, for:.normal)
        }
    }
    
    @IBAction func onInformationDropDown(_ sender: Any) {
        let dropDown = Navigation.jumpToView(currentViewController: self, nextViewController: "DropDownTableViewController",overCurrntContext: true) as! DropDownTableViewController
        dropDown.delegate = self
        dropDown.elements = Symptom.allCases.map({ $0.text })
        dropDown.titleLabel.text = "Select information"
    }
    
    @IBAction func onSubmitInformation(_ sender: Any) {
        if let symptom = self.informationValue, let caseElement = self.caseElement {
        
            let historyElement : HistoryModel = HistoryModel(date: Date.now, symptom: symptom)
            
            APIHealthAssitant.addInformation(patientId: caseElement.patientId, caseId: caseElement.caseId, information: historyElement, onComplete: { history in
                print("Info submitted")
                caseElement.history.append(historyElement)
                
                self.diagnosticLabel.text = "Possible diagnostic: \(self.predictDiagnosis().rawValue)"
                
                self.informationValue = nil
                self.informationDropDown.setTitle("Select information", for:.normal)
                
                self.informationTableView.reloadData()
                print(caseElement.history)
                
            }, onFail: {_ in print("error")})
            
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
        if let caseElement = self.caseElement {
            return caseElement.history.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier) as! InformationTableViewCell
        if let caseElement = self.caseElement {
            let information = caseElement.history[indexPath.row]
            print(information)
            cell.informationLabel.text = "\(information.date.ISO8601Format()) - \(information.symptom.text)"
        }
        return cell
    }
}

