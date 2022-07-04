import Foundation
import SwiftUI

class UserModel {
    let email: String
    let token: String

    init(email: String, token: String) {
        self.email = email
        self.token = token
    }
}
