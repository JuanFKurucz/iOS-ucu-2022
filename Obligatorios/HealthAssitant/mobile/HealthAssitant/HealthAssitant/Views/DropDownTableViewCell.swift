//
//  DropDownTableViewCell.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 30/6/22.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {
    static let identifier : String = "DropDownTableViewCell"
    
    @IBOutlet weak var dropDownTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
