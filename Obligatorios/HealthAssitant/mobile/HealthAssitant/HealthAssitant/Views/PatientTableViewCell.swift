import UIKit

class PatientTableViewCell: UITableViewCell {
    static let identifier: String = "PatientTableViewCell"
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var currentCaseLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
