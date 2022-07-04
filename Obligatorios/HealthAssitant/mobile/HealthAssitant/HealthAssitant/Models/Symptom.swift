import Foundation

enum Symptom: Int, CaseIterable {
    case Unknown = 0, Fever = 1, DryCough = 2, Rhinorrhea = 3, Dyspnea = 4, Fatigue = 5, MusclePain = 6, ChestPain = 7, Anosmia = 8, Dysgeusia = 9, KidneyFailure = 10, Myocarditis = 11, Hemoptisis = 12, Headache = 13

    var text: String {
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

    var identificator: String {
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
