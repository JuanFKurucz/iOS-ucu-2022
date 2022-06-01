//
//  MatchDetailsViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 5/5/22.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class MatchDetailsViewController: UIViewController {
    static let identifier : String = "MatchDetailsViewController"
    var match : Match?
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var matchScoreLabel: UILabel!
    @IBOutlet weak var teamRightImage: UIImageView!
    @IBOutlet weak var teamRightLabel: UILabel!
    @IBOutlet weak var teamLeftImage: UIImageView!
    @IBOutlet weak var teamLeftLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func onGetMatchDetailsSuccess(apiMatch: APIMatchDetails){
        match?.logs = apiMatch.incidences!
        self.tableView.reloadData()
    }
    
    func onGetMatchDetailsFail(error: Error){
        Alert.showAlertBox(currentViewController: self, title: "Api error", message: error.localizedDescription)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 312, height: 23))
        
        let titleView:UIView = UIView.init(frame: rect)
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 312, height: 23))
        label.text = "Detalle partido"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleView.addSubview(label)
        
        self.navigationItem.titleView = titleView
        
        
        if let match = self.match {
            
            APIPenca.getMatchDetails(matchId: match.matchId, onComplete: onGetMatchDetailsSuccess, onFail: onGetMatchDetailsFail)
            
            self.tableView.register(UINib(nibName: MatchLogTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MatchLogTableViewCell.identifier)
            
            // Do any additional setup after loading the view.
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "EEEE d/M"
            self.dateLabel.text = dateFormatterGet.string(from:match.date).capitalizingFirstLetter()
            
            self.statusLabel.text = match.matchStatus.text
            
            self.teamLeftImage.kf.setImage(with: URL(string:match.teamLeft.imageURL))
            self.teamRightImage.kf.setImage(with: URL(string:match.teamRight.imageURL))
            self.teamLeftLabel.text = match.teamLeft.name
            self.teamRightLabel.text = match.teamRight.name
            self.matchScoreLabel.text = "\(match.score!.leftScore) - \(match.score!.rightScore)"
            
            self.statusView.layer.cornerRadius = 4;
            self.statusView.layer.masksToBounds = true;
            self.statusView.backgroundColor = match.matchStatus.color
            self.statusContainer.backgroundColor  = match.matchStatus.color.withAlphaComponent(0.5)
            
        } else {
            Alert.showAlertBox(currentViewController: self, title: "Error", message: "Match does not exist", handler: {_ in
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}


extension MatchDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.match?.logs.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchLogTableViewCell.identifier) as! MatchLogTableViewCell
        let matchLog = self.match?.logs[indexPath.row]
        cell.timeLabel.text = "\(matchLog!.minute)’"
        if matchLog!.side == "left"{
            cell.leftLabel.text = matchLog!.playerName
            cell.rightLabel.text = ""
        } else {
            cell.leftLabel.text = ""
            cell.rightLabel.text = matchLog!.playerName
        }
        cell.iconImage.image = UIImage.init(named:"icon_\(matchLog!.icon)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
