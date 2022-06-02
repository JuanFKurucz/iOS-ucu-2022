import UIKit

protocol MatchTableViewCellDelegate {
    func didTapSaveButton(index: IndexPath?, scoreLeft: Int, scoreRight: Int)
    
    func didTapDetailsButton(index: IndexPath?)
}

class MatchTableViewCell: UITableViewCell {
    
    static let identifier = "MatchTableViewCell"
    
    @IBOutlet weak var matchStatusLabelView: UIView!
    @IBOutlet weak var matchStatusContainerView: UIView!
    @IBOutlet weak var matchStatusLabel: UILabel!
    @IBOutlet weak var teamLeftLabel: UILabel!
    @IBOutlet weak var teamLeftLogo: UIImageView!
    @IBOutlet weak var teamRightLabel: UILabel!
    @IBOutlet weak var teamRightLogo: UIImageView!
    @IBOutlet weak var scoreLeftField: UITextField!
    @IBOutlet weak var scoreRightField: UITextField!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var delegate : MatchTableViewCellDelegate?;
    var indexPath : IndexPath?;
    
    func addTopBorderToButton(button:UIButton, color:UIColor = UIColor(red: 81/255, green: 117/255, blue: 209/255, alpha: 1.0)) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: button.frame.size.width, height: 1)
        button.addSubview(border)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.scoreLeftField.delegate = self
        self.scoreRightField.delegate = self
        self.saveButton.isHidden=true
        
        let icon = UIImage(systemName: "chevron.right")
        
        self.detailsButton.setImage(icon, for: .normal)
        self.detailsButton.tintColor = UIColor(red: 188/255, green: 192/255, blue: 229/255, alpha: 1.0)
        self.detailsButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.detailsButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.detailsButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        
        self.addTopBorderToButton(button: detailsButton)
        self.addTopBorderToButton(button: saveButton)
    }
    
    @IBAction func onClickSaveButton(_ sender: Any) {
        let scoreLeft : Int = Int(Validation.scoreValidation(number: self.scoreLeftField.text ?? "")) ?? 0
        let scoreRight : Int = Int(Validation.scoreValidation(number: self.scoreRightField.text ?? "")) ?? 0
        self.delegate?.didTapSaveButton(index: self.indexPath, scoreLeft: scoreLeft, scoreRight: scoreRight)
        saveButton.isHidden=true
    }
    
    @IBAction func onInputCellChange(_ sender: Any) {
        saveButton.isHidden=false
    }
    
    @IBAction func onTapDetails(_ sender: Any) {
        self.delegate?.didTapDetailsButton(index: indexPath)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
    }
}


extension MatchTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = Validation.scoreValidation(number: textField.text ?? "")
    }
}
