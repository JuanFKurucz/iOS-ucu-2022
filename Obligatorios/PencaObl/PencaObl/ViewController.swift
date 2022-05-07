//
//  ViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 27/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterIcon: UIImageView!
    
    var matchesList: [[Match]] = [];
    var filteredMatchesList: [[Match]] = [];
    var dates: [Date] = [];
    
    var filterTeamName : String?
    var filterMatchStatus : MatchStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CHANGE TO BUTTON
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        filterIcon.isUserInteractionEnabled = true
        filterIcon.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        Database.loadData(jsonPath: "data")
        let matches = Database.matches
        
        var currentDate: Date? = nil
        
        for match in matches {
            if(currentDate == nil || currentDate! != match.date){
                self.matchesList.append([])
                currentDate = match.date
                self.dates.append(match.date)
            }
            self.matchesList[self.matchesList.endIndex-1].append(match)
        }
        
        self.filteredMatchesList = self.matchesList
        
        tableView.register(UINib(nibName: MatchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MatchTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filteredMatchesList.count
    }
    
    func filterMatches(teamName:String?, matchStatus: MatchStatus?) {
        self.filterTeamName = teamName
        self.filterMatchStatus = matchStatus
        
        var currentDate : Date? = nil
        if(self.filterTeamName == nil || self.filterTeamName!.count==0){
            if(self.filterMatchStatus != nil ){
                self.filteredMatchesList = []
                for matches in self.matchesList {
                    for match in matches {
                        if(currentDate == nil || currentDate! != match.date){
                            self.filteredMatchesList.append([])
                            currentDate = match.date
                        }
                        if(match.getMatchStatus() == self.filterMatchStatus){
                            self.filteredMatchesList[self.filteredMatchesList.endIndex-1].append(match)
                        }
                    }
                }
            } else {
                self.filteredMatchesList = self.matchesList
            }
        } else {
            self.filteredMatchesList = []
            for matches in self.matchesList {
                for match in matches {
                    if(match.teamLeft.name.lowercased().contains(self.filterTeamName!.lowercased()) || match.teamRight.name.lowercased().contains(self.filterTeamName!.lowercased())){
                        if(currentDate == nil || currentDate! != match.date){
                            self.filteredMatchesList.append([])
                            currentDate = match.date
                        }
                        if(self.filterMatchStatus == nil || match.getMatchStatus() == self.filterMatchStatus){
                            self.filteredMatchesList[self.filteredMatchesList.endIndex-1].append(match)
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alertController = UIAlertController(title: "Filtrar partidos", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Ver todos", style: .default, handler: {_ in
            self.filterMatches(teamName: self.filterTeamName, matchStatus: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Ver acertados", style: .default, handler: {_ in
            self.filterMatches(teamName: self.filterTeamName, matchStatus: MatchStatus.correct)
        }))
        alertController.addAction(UIAlertAction(title: "Ver errados", style: .default, handler: {_ in
            self.filterMatches(teamName: self.filterTeamName, matchStatus: MatchStatus.missed)
        }))
        alertController.addAction(UIAlertAction(title: "Ver pendientes", style: .destructive, handler: {_ in
            self.filterMatches(teamName: self.filterTeamName, matchStatus: MatchStatus.pending)
        }))
        alertController.addAction(UIAlertAction(title: "Ver jugados s/resultado", style: .default, handler: {_ in
            self.filterMatches(teamName: self.filterTeamName, matchStatus: MatchStatus.noResult)
        }))
        alertController.addAction(UIAlertAction(title: "Filtrar", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterMatches(teamName: searchText, matchStatus: self.filterMatchStatus)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredMatchesList[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier) as! MatchTableViewCell
        let match = self.filteredMatchesList[indexPath.section][indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.matchStatusLabel.text = match.getMatchStatus().text
        
        cell.teamLeftLabel.text = match.teamLeft.name
        cell.teamLeftLogo.image = UIImage.init(named:match.teamLeft.image)
        cell.teamRightLabel.text = match.teamRight.name
        cell.teamRightLogo.image = UIImage.init(named:match.teamRight.image)
        
        if match.getMatchStatus() == MatchStatus.pending {
            cell.detailsButton.isHidden=true
            cell.scoreLeftField.isUserInteractionEnabled=true
            cell.scoreRightField.isUserInteractionEnabled=true
        } else {
            cell.detailsButton.isHidden=false
            cell.scoreLeftField.isUserInteractionEnabled=false
            cell.scoreRightField.isUserInteractionEnabled=false
        }
        
        var score : Score? = nil
        if match.score != nil {
            score = match.score!
        } else if match.guess != nil {
            score = match.guess!
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
        dateFormatterGet.dateFormat = "EEEE d/M"
        return "\(dateFormatterGet.string(from:self.dates[section]))"
    }
}


extension ViewController: MatchTableViewCellDelegate {
    func didTapDetailsButton(index: IndexPath?) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: MatchDetailsViewController.identifier) as! MatchDetailsViewController
        nextViewController.match = self.filteredMatchesList[index!.section][index!.row]
        show(nextViewController, sender: nil)
    }
    
    
    func didTapSaveButton(index: IndexPath?, scoreLeft: Int, scoreRight: Int) {
        let match = self.filteredMatchesList[index!.section][index!.row]
        match.changeGuess(guessScore: Score(leftScore: scoreLeft, rightScore: scoreRight))
        self.view.endEditing(true)
    }
    
}
