//
//  InformationTableViewCell.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

import UIKit

class InformationTableViewCell: UITableViewCell {
    static let identifier : String = "InformationTableViewCell"
    
    @IBOutlet weak var informationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
