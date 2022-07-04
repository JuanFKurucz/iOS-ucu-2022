import UIKit

class CaseTableViewCell: UITableViewCell {
    static let identifier: String = "CaseTableViewCell"
    @IBOutlet var caseName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
