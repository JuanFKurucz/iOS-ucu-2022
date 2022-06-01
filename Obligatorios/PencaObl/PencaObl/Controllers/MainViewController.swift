//
//  ViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 27/4/22.
//

import UIKit

import Kingfisher

class MainViewController: UIViewController {
    static let identifier = "MainViewController"
    
    @IBOutlet weak var tableView: MatchTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    var matchesList: [[Match]] = [];
    var filteredMatchesList: [[Match]] = [];
    var dates: [Date] = [];
    var filteredDates: [Date] = [];
    
    var filterTeamName : String?
    var filterMatchStatus : MatchStatus?
    
    func onGetMatchesSuccess(getMatches: GetMatches){
        self.matchesList = []
        self.filteredMatchesList = []
        self.dates = []
        self.filteredDates = []
        var matches: [Match] = []
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        
        getMatches.matches.forEach { APIMatch in
            var teamLeft : [Team] = Database.teams.filter({$0.id == APIMatch.homeTeamId})
            if(teamLeft.isEmpty){
                teamLeft = [Team(id:APIMatch.homeTeamId,name:APIMatch.homeTeamName,imageURL:APIMatch.homeTeamLogo)]
                Database.teams.append(teamLeft.first!)
            }
            var teamRight : [Team] = Database.teams.filter({$0.id == APIMatch.awayTeamId})
            if(teamRight.isEmpty){
                teamRight = [Team(id:APIMatch.awayTeamId,name:APIMatch.awayTeamName,imageURL:APIMatch.awayTeamLogo)]
                Database.teams.append(teamRight.first!)
            }
            
            var score: Score? = nil
            if let scoreLeft = APIMatch.homeTeamGoals, let scoreRight = APIMatch.awayTeamGoals {
                score = Score(leftScore: scoreLeft, rightScore: scoreRight)
            }
            
            var guess: Score? = nil
            if let guessLeft = APIMatch.predictedHomeGoals, let guessRight = APIMatch.predictedAwayGoals {
                guess = Score(leftScore: guessLeft, rightScore: guessRight)
            }
            
            var matchStatus:MatchStatus
            switch APIMatch.status {
            case "pending": matchStatus = MatchStatus.pending
            case "not_predicted": matchStatus = MatchStatus.notPredicted
            case "correct": matchStatus = MatchStatus.correct
            case "incorrect": matchStatus = MatchStatus.incorrect
            default: matchStatus = MatchStatus.pending
            }
            matches.append(Match(matchId: APIMatch.matchId, teamLeft: teamLeft.first!, teamRight: teamRight.first!, matchStatus: matchStatus, date: formatter.date(from: APIMatch.date)!, score: score, guess: guess))
            
        }
        matches = matches.sorted(by: {$0.date > $1.date})
        
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
        self.filteredDates = self.dates
        
        self.tableView.reloadData()
    }
    
    func onAPIRequestFail(error: Error){
        Alert.showAlertBox(currentViewController: self, title: "Api error", message: error.localizedDescription)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Data loading
        APIPenca.getMatches(onComplete: self.onGetMatchesSuccess, onFail: self.onAPIRequestFail)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Visual components loading
        Visual.addNavBarImage(element:self, showsLogout: true)
        
        // SearchBar
        filterButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        searchBar.delegate = self
        
        //  Table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MatchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MatchTableViewCell.identifier)
    }
    
    /// This function picks the matches from `matchesList` that conform `teamName` and `matchStatus` queries.
    /// and puts them in `filteredMatchesList`
    ///
    /// - Parameter teamName: A string query to filter matches by their team name, it can be `nil` which means no querying
    /// - Parameter matchStatus: A `MatchStatus` element to filter matches by their status, it can be `nil` which means no querying
    func filterMatches(teamName:String?, matchStatus: MatchStatus?) {
        self.filterTeamName = teamName
        self.filterMatchStatus = matchStatus
        var currentDate : Date? = nil
        self.filteredDates = []
        if(self.filterTeamName == nil || self.filterTeamName!.count==0){
            if(self.filterMatchStatus != nil ){
                self.filteredMatchesList = []
                for matches in self.matchesList {
                    for match in matches {
                        if(currentDate == nil || currentDate! != match.date){
                            currentDate = match.date
                        }
                        if(match.matchStatus == self.filterMatchStatus){
                            if (!filteredDates.contains(currentDate!)){
                                self.filteredDates.append(currentDate!)
                                self.filteredMatchesList.append([])
                            }
                            self.filteredMatchesList[self.filteredMatchesList.endIndex-1].append(match)
                        }
                    }
                }
            } else {
                self.filteredMatchesList = self.matchesList
                self.filteredDates = self.dates
            }
        } else {
            self.filteredMatchesList = []
            for matches in self.matchesList {
                for match in matches {
                    if(match.teamLeft.name.lowercased().contains(self.filterTeamName!.lowercased()) || match.teamRight.name.lowercased().contains(self.filterTeamName!.lowercased())){
                        if(currentDate == nil || currentDate! != match.date){
                            currentDate = match.date
                        }
                        if(self.filterMatchStatus == nil || match.matchStatus == self.filterMatchStatus){
                            if (!filteredDates.contains(currentDate!)){
                                self.filteredDates.append(currentDate!)
                                self.filteredMatchesList.append([])
                            }
                            self.filteredMatchesList[self.filteredMatchesList.endIndex-1].append(match)
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func onExternalFilterError(error: Error, matchStatus: MatchStatus?){
        self.onAPIRequestFail(error: error)
        APIPenca.getMatches(onComplete: { getMatches in
            self.onGetMatchesSuccess(getMatches: getMatches)
            self.filterMatches(teamName: self.filterTeamName, matchStatus: matchStatus)
        }, onFail: self.onAPIRequestFail, teamName: self.filterTeamName)
    }
    
    @IBAction func tappedFilterButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Filtrar partidos", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Ver todos", style: .default, handler: {_ in
            APIPenca.getMatches(onComplete: self.onGetMatchesSuccess, onFail: self.onAPIRequestFail, teamName: self.filterTeamName)
        }))
        alertController.addAction(UIAlertAction(title: "Ver acertados", style: .default, handler: {_ in
            APIPenca.getMatches(onComplete: self.onGetMatchesSuccess, onFail:  { error in
                self.onExternalFilterError(error: error, matchStatus: MatchStatus.correct)
            }, teamName: self.filterTeamName, status: MatchStatus.correct.encoding)
        }))
        alertController.addAction(UIAlertAction(title: "Ver errados", style: .default, handler: {_ in
            APIPenca.getMatches(onComplete: self.onGetMatchesSuccess, onFail:  { error in
                self.onExternalFilterError(error: error, matchStatus: MatchStatus.incorrect)
            }, teamName: self.filterTeamName, status: MatchStatus.incorrect.encoding)
        }))
        alertController.addAction(UIAlertAction(title: "Ver pendientes", style: .destructive, handler: {_ in
            APIPenca.getMatches(onComplete: self.onGetMatchesSuccess, onFail:  { error in
                self.onExternalFilterError(error: error, matchStatus: MatchStatus.pending)
            }, teamName: self.filterTeamName, status: MatchStatus.pending.encoding)
        }))
        alertController.addAction(UIAlertAction(title: "Ver jugados s/resultado", style: .default, handler: {_ in
            APIPenca.getMatches(onComplete: self.onGetMatchesSuccess, onFail: { error in
                self.onExternalFilterError(error: error, matchStatus: MatchStatus.notPredicted)
            }, teamName: self.filterTeamName, status: MatchStatus.notPredicted.encoding)
        }))
        alertController.addAction(UIAlertAction(title: "Filtrar", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension MainViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterTeamName = searchText
        APIPenca.getMatches(onComplete: self.onGetMatchesSuccess, onFail: self.onAPIRequestFail, teamName: self.filterTeamName)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredMatchesList[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.filteredMatchesList.count == 0 {
            self.tableView.setMessage(message: "Sin resultados encontrados")
        } else {
            self.tableView.restore()
        }
        return self.filteredMatchesList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        tableView.sectionIndexBackgroundColor = UIColor.clear
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
            headerView.textLabel?.backgroundColor = UIColor.clear
            headerView.contentView.backgroundColor = UIColor.clear
            headerView.backgroundView?.backgroundColor = UIColor.clear
            headerView.backgroundColor = UIColor.clear
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MatchTableViewCell.identifier) as! MatchTableViewCell
        let match = self.filteredMatchesList[indexPath.section][indexPath.row]
        print("Creating match: \(match.teamLeft.name) vs \(match.teamRight.name) with index \(indexPath.section),\(indexPath.row)")
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.matchStatusLabel.text = match.matchStatus.text
        cell.matchStatusLabelView.layer.cornerRadius = 4
        cell.matchStatusLabelView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 4
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = CGColor(red: 81/255, green: 117/255, blue: 209/255, alpha: 1.0)
        
        cell.matchStatusLabelView.backgroundColor = match.matchStatus.color
        cell.matchStatusContainerView.backgroundColor  = match.matchStatus.color.withAlphaComponent(0.5)
        
        
        cell.teamLeftLabel.text = match.teamLeft.name
        cell.teamLeftLogo.kf.setImage(with: URL(string:match.teamLeft.imageURL))
        cell.teamRightLabel.text = match.teamRight.name
        cell.teamRightLogo.kf.setImage(with: URL(string:match.teamRight.imageURL))
        
        if match.matchStatus == MatchStatus.pending {
            cell.detailsButton.isHidden=true
            cell.scoreLeftField.isUserInteractionEnabled=true
            cell.scoreRightField.isUserInteractionEnabled=true
        } else {
            cell.detailsButton.isHidden=false
            cell.scoreLeftField.isUserInteractionEnabled=false
            cell.scoreRightField.isUserInteractionEnabled=false
        }
        
        var score : Score? = nil
        if let matchScore = match.score {
            score = matchScore
        } else if let matchGuess = match.guess {
            score = matchGuess
        }
        
        if let scoreValue = score {
            print("Score value: \(scoreValue.leftScore) vs \(scoreValue.rightScore)")
            cell.scoreLeftField.text = "\(scoreValue.leftScore)"
            cell.scoreRightField.text = "\(scoreValue.rightScore)"
        } else {
            cell.scoreLeftField.text = ""
            cell.scoreRightField.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 188
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEEE d/M/Y"
        return "\(dateFormatterGet.string(from:self.filteredDates[section]).capitalizingFirstLetter())"
    }
}


extension MainViewController: MatchTableViewCellDelegate {
    func didTapDetailsButton(index: IndexPath?) {
        let nextViewController = Navigation.jumpToView(currentViewController: self,nextViewController: MatchDetailsViewController.identifier) as! MatchDetailsViewController
        nextViewController.match = self.filteredMatchesList[index!.section][index!.row]
    }
    
    func onPredictMatchComplete(result: APIPredictMatch){
        self.view.endEditing(true)
    }
    
    func onPredictMatchFail(error: Error){
        self.view.endEditing(true)
        onAPIRequestFail(error: error)
    }
    
    func didTapSaveButton(index: IndexPath?, scoreLeft: Int, scoreRight: Int) {
        let match = self.filteredMatchesList[index!.section][index!.row]
        print("Save prediction on: \(match.teamLeft.name) vs \(match.teamRight.name)")
        if(match.changeGuess(guessScore: Score(leftScore: scoreLeft, rightScore: scoreRight))){
            APIPenca.predictMatch(matchId: match.matchId, homeGoals: scoreLeft, awayGoals: scoreRight, onComplete: onPredictMatchComplete, onFail: onPredictMatchFail)
        }
    }
}
