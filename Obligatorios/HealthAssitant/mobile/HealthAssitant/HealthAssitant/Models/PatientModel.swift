import Foundation

class PatientModel {
    let patientId: Int
    let identification: String
    let fullName: String
    let gender: Gender
    let birthDate: Date?
    var cases: [CaseModel]
    let imageBase64: String

    init(identification: String, patientId: Int, fullName: String, imageBase64: String, gender: Gender, birthDate: Date?, cases: [CaseModel] = []) {
        self.patientId = patientId
        self.identification = identification
        self.fullName = fullName
        self.gender = gender
        self.birthDate = birthDate
        self.cases = cases
        self.imageBase64 = imageBase64
    }

    func getInformation() -> String {
        return "\(identification) - \(fullName)"
    }
}
