//
//  PatientTableViewCell.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 22/6/22.
//

import UIKit

class PatientTableViewCell: UITableViewCell {
    static let identifier : String = "PatientTableViewCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentCaseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
