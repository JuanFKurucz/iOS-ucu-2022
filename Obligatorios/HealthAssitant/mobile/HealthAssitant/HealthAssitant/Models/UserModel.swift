import Foundation
import SwiftUI

class UserModel {
    let email: String
    let token: String
    
    init(email:String, token: String){
        self.email = email
        self.token = token
    }
}

enum Gender: String {
    case male, female
    
    var text : String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        default: return self.rawValue
        }
    }
}


enum Diagnosis: String, CaseIterable {
    case COVID19, Influenza, CommonCold, Tuberculosis, LungCancer, PneumoniaCOVID19, Pneumonia, BrainTumor
}


enum Symptom: String, CaseIterable {
    case Fever, DryCough, Rhinorrhea, Dyspnea, Fatigue, MusclePain, ChestPain, Anosmia, Dysgeusia, KidneyFailure, Myocarditis, Hemoptisis, Headache
}


class PatientModel {
    let identification: String
    let fullName: String
    let gender: Gender
    let birthDate: Date
    let cases: [CaseModel]
    
    init(identification:String, fullName: String, gender:Gender, birthDate: Date, cases: [CaseModel] = []){
        self.identification = identification
        self.fullName = fullName
        self.gender = gender
        self.birthDate = birthDate
        self.cases = cases
    }
    
    func getOrCreateCurrentCase() -> CaseModel? {
        for caseElement in self.cases {
            if let _ = caseElement.endDate {
                return caseElement
            }
        }
        return CaseModel(startDate: Date.now, endDate: nil, history: [], diagnosis: nil)
    }
}

class CaseModel {
    let startDate: Date
    var endDate: Date?
    var history: [HistoryModel]
    var diagnosis: Diagnosis?
    
    init(startDate: Date, endDate: Date?, history: [HistoryModel], diagnosis: Diagnosis?){
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
        if let endDate = self.endDate, let diagnosis = self.diagnosis {
            return "\(diagnosis.rawValue) - \(self.startDate) - \(endDate)"
        }
        return"\(self.getCaseStatus()) - \(self.startDate)"
    }
    
    func addInformation(symptom:Symptom, date: Date?){
        let historyElement : HistoryModel
        if let date = date {
            historyElement = HistoryModel(date: date, symptom: symptom)
        } else {
            historyElement = HistoryModel(date: Date.now, symptom: symptom)
        }
        self.history.append(historyElement)
    }
    
    func endCase(date: Date, diagnosis: Diagnosis){
        self.endDate = date
        self.diagnosis = diagnosis
    }
}

struct HistoryModel {
    let date: Date
    let symptom: Symptom
}
