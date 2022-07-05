import UIKit

class CloseCaseViewController: UIViewController, DropDownTableViewControllerDelegate {
    static let identifier: String = "CloseCaseViewController"

    @IBOutlet var diagnosticLabel: UILabel!
    @IBOutlet var diagnosticDropDown: UIButton!
    var diagnosisValue: Diagnosis?
    var caseElement: CaseModel?
    var delegate: CaseViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_: Bool) {
        if let caseElement = caseElement {
            Alert.showLoader(currentViewController: self,completion: {
                APIHealthAssitant.predictDiagnostic(caseElem: caseElement, onComplete: { diagnosis in
                    Alert.hideLoader(currentViewController: self,completion: {
                        self.diagnosticLabel.text = "Possible diagnostic: \(diagnosis.text)"
                    })
                }, onFail: { _ in
                    Alert.hideLoader(currentViewController: self, completion: {
                    Alert.showAlertBox(currentViewController: self, title: "Invalid predict diagnostic", message: "Could not predict diagnostic")
                    })
                })
            })
        }
    }

    @IBAction func onCloseCase(_: Any) {
        if let diagnosis = diagnosisValue {
            caseElement!.endCase(date: Date.now, diagnosis: diagnosis)
            delegate?.onTerminateCase()
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onSelectDiagnostic(_: Any) {
        let dropDown = Navigation.jumpToView(currentViewController: self, nextViewController: "DropDownTableViewController", overCurrntContext: true) as! DropDownTableViewController
        dropDown.delegate = self
        dropDown.elements = Diagnosis.allCases.map { $0.text }
        dropDown.titleLabel.text = "Select diagnostic"
    }

    func getSelected(element: Int) {
        if element >= Diagnosis.allCases.count {
            diagnosisValue = nil
            diagnosticDropDown.setTitle("Select diagnostic", for: .normal)
        } else {
            diagnosisValue = Diagnosis.allCases[element]
            diagnosticDropDown.setTitle(Diagnosis.allCases[element].text, for: .normal)
        }
    }
}
