//
//  NumberTableViewCell.swift
//  TableExcerise
//
//  Created by Juan Francisco Kurucz on 7/4/22.
//

import UIKit

protocol NumberTableViewCellDelegate {
    func didTapAddButton(index: IndexPath?)
}

class NumberTableViewCell: UITableViewCell {
    
    static let identifier = "NumberTableViewCell"

    @IBOutlet weak var mainLabel: UILabel!
    
    var delegate : NumberTableViewCellDelegate?;
    var indexPath : IndexPath?;
    
    @IBAction func buttonAction(_ sender: Any) {
        delegate?.didTapAddButton(index:indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

