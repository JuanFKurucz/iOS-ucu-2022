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
    
    var matchesList: [[Match]] = [];
    var filteredMatchesList: [[Match]] = [];
    var dates: [Date] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension ViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count==0){
            self.filteredMatchesList = self.matchesList
        } else {
            var currentDate : Date? = nil
            self.filteredMatchesList = []
            for matches in self.matchesList {
                for match in matches {
                    if(match.teamLeft.name.lowercased().contains(searchText.lowercased()) || match.teamRight.name.lowercased().contains(searchText.lowercased())){
                        if(currentDate == nil || currentDate! != match.date){
                            self.filteredMatchesList.append([])
                            currentDate = match.date
                        }
                        self.filteredMatchesList[self.filteredMatchesList.endIndex-1].append(match)
                    }
                }
            }
        }
        self.tableView.reloadData()
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
        cell.matchStatusLabel.text = "\(match.getMatchStatus().text)"
        
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
        dateFormatterGet.dateFormat = "EEEE dd/MM"
        return "\(dateFormatterGet.string(from:self.dates[section]))"
    }
}


extension ViewController: MatchTableViewCellDelegate {
    
    func didTapSaveButton(index: IndexPath?, scoreLeft: Int, scoreRight: Int) {
        let match = self.filteredMatchesList[index!.section][index!.row]
        match.changeGuess(guessScore: Score(leftScore: scoreLeft, rightScore: scoreRight))
        self.view.endEditing(true)
    }
    
}
