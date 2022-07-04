import Foundation

enum Diagnosis: Int, CaseIterable {
    case Unknown = 0, COVID19 = 1, Influenza = 2, CommonCold = 3, Tuberculosis = 4, LungCancer = 5, PneumoniaCOVID19 = 6, Pneumonia = 7, BrainTumor = 8

    var text: String {
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
