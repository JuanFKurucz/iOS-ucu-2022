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

enum Gender: Int {
    case male = 1, female = 2
    
    var text : String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        default: return "Unknown"
        }
    }
}


enum Diagnosis: Int, CaseIterable {
    case Unknown = 0, COVID19 = 1, Influenza = 2, CommonCold = 3, Tuberculosis = 4, LungCancer = 5, PneumoniaCOVID19 = 6, Pneumonia = 7, BrainTumor = 8
    
    var text : String {
        switch self {
        case .COVID19: return "COVID-19"
        case .Influenza: return "Influenza"
        case .CommonCold: return "Common Cold"
        case .Tuberculosis: return "Tuberculosis"
        case .LungCancer: return "Lung Cancer"
        case .PneumoniaCOVID19: return "Pneumonia COVID19"
        case .Pneumonia: return "Pneumonia"
        case .BrainTumor: return "Brain Tumor"
        default: return "Unknown"
        }
    }
}


enum Symptom: Int, CaseIterable {
    case Unknown = 0,Fever = 1, DryCough = 2, Rhinorrhea = 3, Dyspnea = 4, Fatigue = 5, MusclePain = 6, ChestPain = 7, Anosmia = 8, Dysgeusia = 9, KidneyFailure = 10, Myocarditis = 11, Hemoptisis = 12, Headache = 13
    
    var text : String {
        switch self {
        case .Fever: return "Fever"
        case .DryCough: return "Dry Cough"
        case .Rhinorrhea: return "Rhinorrhea"
        case .Dyspnea: return "Dyspnea"
        case .Fatigue: return "Fatigue"
        case .MusclePain: return "Muscle Pain"
        case .ChestPain: return "Chest Pain"
        case .Anosmia: return "Anosmia"
        case .Dysgeusia: return "Dysgeusia"
        case .KidneyFailure: return "Kidney Failure"
        case .Myocarditis: return "Myocarditis"
        case .Hemoptisis: return "Hemoptisis"
        case .Headache: return "Headache"
        default: return "Unknown"
        }
    }
    
    var identificator : String {
        switch self {
        case .Fever: return "Fever"
        case .DryCough: return "DryCough"
        case .Rhinorrhea: return "Rhinorrhea"
        case .Dyspnea: return "Dyspnea"
        case .Fatigue: return "Fatigue"
        case .MusclePain: return "Myalgia"
        case .ChestPain: return "ChestPain"
        case .Anosmia: return "Anosmia"
        case .Dysgeusia: return "Dysgeusia"
        case .KidneyFailure: return "RenalFailure"
        case .Myocarditis: return "Myocarditis"
        case .Hemoptisis: return "Hemoptysis"
        case .Headache: return "Cephalea"
        default: return "Unknown"
        }
    }
}


class PatientModel {
    let patientId: Int
    let identification: String
    let fullName: String
    let gender: Gender
    let birthDate: Date?
    var cases: [CaseModel]
    let imageBase64: String
    
    init(identification:String, patientId: Int, fullName: String, imageBase64:String, gender:Gender, birthDate: Date?, cases: [CaseModel] = []){
        self.patientId = patientId
        self.identification = identification
        self.fullName = fullName
        self.gender = gender
        self.birthDate = birthDate
        self.cases = cases
        self.imageBase64 = imageBase64
    }
    
    func getInformation() -> String {
        return "\(self.identification) - \(self.fullName)"
    }
}

class CaseModel {
    let patientId : Int
    let caseId : Int
    let startDate: Date
    var endDate: Date?
    var history: [HistoryModel]
    var diagnosis: Diagnosis?
    
    init(patientId: Int, caseId: Int, startDate: Date, endDate: Date?, history: [HistoryModel], diagnosis: Diagnosis?){
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
        if let endDate = self.endDate, let diagnosis = self.diagnosis {
            
            return "\(diagnosis.rawValue) - \(TextManipulation.dateToText(date: self.startDate)) - \(TextManipulation.dateToText(date: endDate))"
        }
        return"\(self.getCaseStatus()) - \(TextManipulation.dateToText(date: self.startDate))"
    }
    
    func endCase(date: Date, diagnosis: Diagnosis){
        self.endDate = date
        self.diagnosis = diagnosis
    }
}

struct HistoryModel {
    let date: Date
    let symptom: Symptom
    let state: Bool
}
