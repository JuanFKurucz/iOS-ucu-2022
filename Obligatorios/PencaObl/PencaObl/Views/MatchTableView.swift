//
//  MatchTableView.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 10/5/22.
//

import UIKit

class MatchTableView: UITableView {

    func setMessage(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
    }
}
