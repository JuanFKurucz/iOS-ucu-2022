//
//  ViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 27/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var matches: [Match] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let teamNacional : Team = Team(name: "Nacional", image: "nacional.png")
        let teamPeñarol : Team = Team(name: "Peñarol", image: "peñarol.png")
        let teamDefensor : Team = Team(name: "Defensor", image: "defensor.png")
        let teamDanubio : Team = Team(name: "Danubio", image: "danubio.png")
        
        
        matches.append(Match(teamLeft: teamNacional, teamRight: teamPeñarol, date: Date()))
        matches.append(Match(teamLeft: teamNacional, teamRight: teamDefensor, date: Date()))
        matches.append(Match(teamLeft: teamDanubio, teamRight: teamDefensor, date: Date()))
        matches.append(Match(teamLeft: teamDanubio, teamRight: teamPeñarol, date: Date()))
        
        tableView.register(UINib(nibName: NumberTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NumberTableViewCell.identifier)
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NumberTableViewCell.identifier) as! NumberTableViewCell
        let match = self.matches[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.matchStatusLabel.text = "\(match.getMatchStatus())"
        cell.scoreLabel.text = "0 - 0"
        cell.teamLeftLabel.text = match.getTeamLeft().getName()
        cell.teamRightLabel.text = match.getTeamRight().getName()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Viernes 26/4"
    }
}


extension ViewController: NumberTableViewCellDelegate {
    
    func didTapAddButton(index: IndexPath?) {
        print("pressed \(String(describing: index?.row))")
    }
    
}
