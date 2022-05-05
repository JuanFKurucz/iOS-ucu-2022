//
//  ViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 27/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var matchesList: [[Match]] = [];
    var dates: [Date] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let teamNacional : Team = Team(name: "Nacional", image: "nacional.png")
        let teamPeñarol : Team = Team(name: "Peñarol", image: "peñarol.png")
        let teamDefensor : Team = Team(name: "Defensor", image: "defensor.png")
        let teamDanubio : Team = Team(name: "Danubio", image: "danubio.png")
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var matches : [Match] = [];
        
        matches.append(Match(teamLeft: teamDanubio, teamRight: teamPeñarol, date: dateFormatterGet.date(from: "2022-05-03 00:00:00")!, matchPlayed: true, score: Score(leftScore: 3, rightScore: 1), guess: Score(leftScore: 3, rightScore: 1)))
        matches.append(Match(teamLeft: teamNacional, teamRight: teamPeñarol, date: dateFormatterGet.date(from: "2022-05-05 00:00:00")!))
        matches.append(Match(teamLeft: teamNacional, teamRight: teamDanubio, date: dateFormatterGet.date(from: "2022-05-05 00:00:00")!, guess:Score(leftScore: 1, rightScore: 3)))
        matches.append(Match(teamLeft: teamNacional, teamRight: teamDefensor, date: dateFormatterGet.date(from: "2022-05-04 00:00:00")!, matchPlayed: true, score: Score(leftScore: 0, rightScore: 0)))
        matches.append(Match(teamLeft: teamDanubio, teamRight: teamDefensor, date: dateFormatterGet.date(from: "2022-05-04 00:00:00")!, matchPlayed: true, score: Score(leftScore: 2, rightScore: 2), guess: Score(leftScore: 1, rightScore: 1)))
        
        
        
        matches = matches.sorted(by: {$0.getDate() > $1.getDate()})
        var currentDate: Date? = nil
        for match in matches {
            if(currentDate == nil || currentDate! != match.getDate()){
                self.matchesList.append([])
                currentDate = match.getDate()
                self.dates.append(match.getDate())
            }
            
            self.matchesList[self.matchesList.endIndex-1].append(match)
        }
        
        tableView.register(UINib(nibName: MatchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MatchTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.matchesList.count
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.matchesList[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier) as! MatchTableViewCell
        let match = self.matchesList[indexPath.section][indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.matchStatusLabel.text = "\(match.getMatchStatus())"
        
        cell.teamLeftLabel.text = match.getTeamLeft().getName()
        cell.teamRightLabel.text = match.getTeamRight().getName()
        
        if match.getMatchStatus() == MatchStatus.Pendiente {
            cell.detailsButton.isHidden=true
            cell.scoreLeftField.isUserInteractionEnabled=true
            cell.scoreRightField.isUserInteractionEnabled=true
        } else {
            cell.detailsButton.isHidden=false
            cell.scoreLeftField.isUserInteractionEnabled=false
            cell.scoreRightField.isUserInteractionEnabled=false
        }
        
        var score : Score? = nil
        if match.getScore() != nil {
            score = match.getScore()!
        } else if match.getGuess() != nil {
            score = match.getGuess()!
        }
        
        if score != nil {
            cell.scoreLeftField.text = "\(score!.leftScore)"
            cell.scoreRightField.text = "\(score!.rightScore)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEEE dd/MM"
        return "\(dateFormatterGet.string(from:self.dates[section]))"
    }
}


extension ViewController: MatchTableViewCellDelegate {
    
    func didTapSaveButton(index: IndexPath?, scoreLeft: Int, scoreRight: Int) {
        let match = self.matchesList[index!.section][index!.row]
        match.changeGuess(guessScore: Score(leftScore: scoreLeft, rightScore: scoreRight))
        self.view.endEditing(true)
    }
    
}
