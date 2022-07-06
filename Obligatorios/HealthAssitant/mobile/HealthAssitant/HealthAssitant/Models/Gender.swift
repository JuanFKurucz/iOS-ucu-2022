import Foundation

enum Gender: Int, CaseIterable {
    case unknown = 0, male = 1, female = 2

    var text: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        default: return "Unknown"
        }
    }
}
