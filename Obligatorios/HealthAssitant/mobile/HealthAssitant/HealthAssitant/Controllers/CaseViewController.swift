import UIKit

protocol CaseViewControllerDelegate {
    func onTerminateCase()
}

class CaseViewController: UIViewController, DropDownTableViewControllerDelegate, CaseViewControllerDelegate {
    static let identifier: String = "CaseViewController"
    @IBOutlet var caseNameLabel: UILabel!
    @IBOutlet var diagnosticLabel: UILabel!
    @IBOutlet var testLabel: UILabel!
    @IBOutlet var informationTableView: UITableView!

    @IBOutlet var informationDropDown: UIButton!
    var caseElement: CaseModel?

    var informationValue: Symptom?

    override func viewDidLoad() {
        super.viewDidLoad()

        informationTableView.delegate = self
        informationTableView.dataSource = self

        informationTableView.register(UINib(nibName: InformationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InformationTableViewCell.identifier)
    }

    func onGetCase() {
        if let caseElement = caseElement {
            caseNameLabel.text = caseElement.getName()
            informationTableView.reloadData()
            Alert.showLoader(currentViewController: self, completion: {
                APIHealthAssitant.predictDiagnostic(caseElem: caseElement, onComplete: { diagnosis in
                    Alert.hideLoader(currentViewController: self, completion: {
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

    func onTerminateCase() {
        if let caseElement = caseElement {
            APIHealthAssitant.closeCase(patientId: caseElement.patientId, caseId: caseElement.caseId, diagnostic: caseElement.diagnosis!, date: caseElement.endDate!, onComplete: {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }, onFail: { _ in
                Alert.hideLoader(currentViewController: self, completion: {
                    Alert.showAlertBox(currentViewController: self, title: "Invalid close case", message: "Could not close case")
                })
            })
        }
    }

    func getSelected(element: Int) {
        if element >= Symptom.allCases.count {
            informationValue = nil
            informationDropDown.setTitle("Select information", for: .normal)
        } else {
            informationValue = Symptom.allCases[element]
            informationDropDown.setTitle(Symptom.allCases[element].text, for: .normal)
        }
    }

    @IBAction func onInformationDropDown(_: Any) {
        let dropDown = Navigation.jumpToView(currentViewController: self, nextViewController: "DropDownTableViewController", overCurrntContext: true) as! DropDownTableViewController
        dropDown.delegate = self
        dropDown.elements = Symptom.allCases.map { $0.text }
        dropDown.titleLabel.text = "Select information"
    }

    private func submitInformation(historyElement: HistoryModel) {
        if let caseElement = caseElement {
            Alert.showLoader(currentViewController: self, completion: {
                APIHealthAssitant.addInformation(patientId: caseElement.patientId, caseId: caseElement.caseId, information: historyElement, onComplete: { _ in
                    Alert.hideLoader(currentViewController: self, completion: {
                        caseElement.history.append(historyElement)
                        APIHealthAssitant.predictDiagnostic(caseElem: caseElement, onComplete: { diagnosis in
                            self.diagnosticLabel.text = "Possible diagnostic: \(diagnosis.text)"
                        }, onFail: { _ in
                            Alert.showAlertBox(currentViewController: self, title: "Invalid predict diagnostic", message: "Could not predict diagnostic")
                        })

                        self.informationValue = nil
                        self.informationDropDown.setTitle("Select information", for: .normal)

                        self.informationTableView.reloadData()
                    })
                }, onFail: { _ in
                    Alert.hideLoader(currentViewController: self, completion: {
                        Alert.showAlertBox(currentViewController: self, title: "Invalid add information", message: "Could not add information")
                    })
                })
            })
        } else {
            Alert.showAlertBox(currentViewController: self, title: "Invalid add information", message: "Could not obtain case element")
        }
    }

    @IBAction func onSubmitNegativeInformation(_: Any) {
        if let symptom = informationValue {
            let historyElement = HistoryModel(date: Date.now, symptom: symptom, state: false)
            submitInformation(historyElement: historyElement)
        }
    }

    @IBAction func onSubmitPositiveInformation(_: Any) {
        if let symptom = informationValue {
            let historyElement = HistoryModel(date: Date.now, symptom: symptom, state: true)
            submitInformation(historyElement: historyElement)
        }
    }

    @IBAction func onCloseCase(_: Any) {
        let closeCaseView = Navigation.jumpToView(currentViewController: self, nextViewController: "CloseCaseViewController") as! CloseCaseViewController
        closeCaseView.caseElement = caseElement
        closeCaseView.delegate = self
    }
}

extension CaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if let caseElement = caseElement {
            return caseElement.history.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier) as! InformationTableViewCell
        if let caseElement = caseElement {
            let information = caseElement.history[indexPath.row]

            let stateInfo = information.state == false ? "Negative" : "Positive"

            cell.informationLabel.text = "\(TextManipulation.dateToText(date: information.date)) - \(information.symptom.text) - \(stateInfo)"
        }
        return cell
    }
}
