import Foundation

class CaseModel {
    let patientId: Int
    let caseId: Int
    let startDate: Date
    var endDate: Date?
    var history: [HistoryModel]
    var diagnosis: Diagnosis?

    init(patientId: Int, caseId: Int, startDate: Date, endDate: Date?, history: [HistoryModel], diagnosis: Diagnosis?) {
        self.patientId = patientId
        self.caseId = caseId
        self.startDate = startDate
        self.endDate = endDate
        self.history = history
        self.diagnosis = diagnosis
    }

    func getCaseStatus() -> String {
        if let _ = endDate {
            return "Concluded"
        }
        return "Ongoing"
    }

    func getName() -> String {
        if let endDate = endDate, let diagnosis = diagnosis {
            return "\(diagnosis.rawValue) - \(TextManipulation.dateToText(date: startDate)) - \(TextManipulation.dateToText(date: endDate))"
        }
        return"\(getCaseStatus()) - \(TextManipulation.dateToText(date: startDate))"
    }

    func endCase(date: Date, diagnosis: Diagnosis) {
        endDate = date
        self.diagnosis = diagnosis
    }
}
