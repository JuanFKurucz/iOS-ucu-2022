import Foundation

enum Gender: Int {
    case male = 1, female = 2

    var text: String {
        switch self {
        case .male: return "Male"
        case .female: return "Female"
        }
    }
}
