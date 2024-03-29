import UIKit

class PatientTableViewCell: UITableViewCell {
    static let identifier: String = "PatientTableViewCell"
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var identificationLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var backgroundRectView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundRectView.layer.cornerRadius = 16
        backgroundRectView.clipsToBounds = true
    }
}
