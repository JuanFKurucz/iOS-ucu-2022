import UIKit

protocol MatchTableViewCellDelegate {
    func didTapSaveButton(index: IndexPath?, scoreLeft: Int, scoreRight: Int)
}

class MatchTableViewCell: UITableViewCell {
    
    static let identifier = "MatchTableViewCell"

    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var teamLeftLabel: UILabel!
    @IBOutlet weak var teamRightLabel: UILabel!
    @IBOutlet weak var scoreLeftField: UITextField!
    @IBOutlet weak var scoreRightField: UITextField!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var delegate : MatchTableViewCellDelegate?;
    var indexPath : IndexPath?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.isHidden=true
    }
    
    @IBAction func onClickSaveButton(_ sender: Any) {
        let scoreLeft : Int = Int(self.scoreLeftField.text ?? "") ?? 0
        let scoreRight : Int = Int(self.scoreRightField.text ?? "") ?? 0
        self.delegate?.didTapSaveButton(index: self.indexPath, scoreLeft: scoreLeft, scoreRight: scoreRight)
        saveButton.isHidden=true
    }
    
    @IBAction func onInputCellChange(_ sender: Any) {
        saveButton.isHidden=false
    }
    
}
