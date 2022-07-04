import Foundation
import UIKit

class ImageUtils {
    static func base64ToImage(base64: String) -> UIImage? {
        if let dataDecoded = Data(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0)) {
            return UIImage(data: dataDecoded)!
        }
        return nil
    }
}
