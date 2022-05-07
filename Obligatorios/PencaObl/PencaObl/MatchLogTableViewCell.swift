//
//  MatchLogTableViewCell.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 7/5/22.
//

import UIKit

class MatchLogTableViewCell: UITableViewCell {
    
    static let identifier = "MatchLogTableViewCell"

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
