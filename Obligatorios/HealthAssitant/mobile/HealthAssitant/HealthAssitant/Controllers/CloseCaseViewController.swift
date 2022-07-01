//
//  CloseCaseViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

import UIKit

class CloseCaseViewController: UIViewController, DropDownTableViewControllerDelegate {
    static let identifier : String = "CloseCaseViewController"
    
    @IBOutlet weak var diagnosticLabel: UILabel!
    @IBOutlet weak var diagnosticDropDown: UIButton!
    var diagnosisValue : Diagnosis?
    var caseElement : CaseModel?
    var delegate : CaseViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCloseCase(_ sender: Any) {
        if let diagnosis = diagnosisValue {
            caseElement!.endCase(date:Date.now, diagnosis: diagnosis)
            delegate?.onTerminateCase()
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onSelectDiagnostic(_ sender: Any) {
        let dropDown = Navigation.jumpToView(currentViewController: self, nextViewController: "DropDownTableViewController",overCurrntContext: true) as! DropDownTableViewController
        dropDown.delegate = self
        dropDown.elements = Diagnosis.allCases.map({ $0.rawValue })
        dropDown.titleLabel.text = "Select diagnostic"
    
    }
    
    func getSelected(element: Int) {
        if element >= Diagnosis.allCases.count {
            self.diagnosisValue = nil
            self.diagnosticDropDown.setTitle("Select diagnostic", for:.normal)
        } else {
            self.diagnosisValue = Diagnosis.allCases[element]
            self.diagnosticDropDown.setTitle(Diagnosis.allCases[element].rawValue, for:.normal)
        }
    }
}
