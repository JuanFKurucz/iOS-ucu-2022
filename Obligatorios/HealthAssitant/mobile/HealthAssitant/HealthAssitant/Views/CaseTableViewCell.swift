//
//  CaseTableViewCell.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

import UIKit

class CaseTableViewCell: UITableViewCell {
    static let identifier : String = "CaseTableViewCell"
    @IBOutlet weak var caseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
