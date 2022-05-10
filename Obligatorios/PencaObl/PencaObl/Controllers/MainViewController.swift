//
//  ViewController.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 27/4/22.
//

import UIKit

class MainViewController: UIViewController {
    static let identifier = "MainViewController"
    
    @IBOutlet weak var tableView: MatchTableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    var matchesList: [[Match]] = [];
    var filteredMatchesList: [[Match]] = [];
    var dates: [Date] = [];
    
    var filterTeamName : String?
    var filterMatchStatus : MatchStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data loading
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
        
        // Visual components loading
        
        Visual.addNavBarImage(element:self)
        
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
    
    @IBAction func tappedFilterButton(_ sender: Any) {
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

extension MainViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterMatches(teamName: searchText, matchStatus: self.filterMatchStatus)
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
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.matchStatusLabel.text = match.getMatchStatus().text
        cell.matchStatusLabelView.layer.cornerRadius = 4
        cell.matchStatusLabelView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 4
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = CGColor(red: 81/255, green: 117/255, blue: 209/255, alpha: 1.0)
        
        cell.matchStatusLabelView.backgroundColor = match.getMatchStatus().color
        cell.matchStatusContainerView.backgroundColor  = match.getMatchStatus().color.withAlphaComponent(0.5)
        
        
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
        return 188
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEEE d/M"
        return "\(dateFormatterGet.string(from:self.dates[section]).capitalizingFirstLetter())"
    }
}


extension MainViewController: MatchTableViewCellDelegate {
    func didTapDetailsButton(index: IndexPath?) {
        let nextViewController = Navigation.jumpToView(currentViewController: self,nextViewController: MatchDetailsViewController.identifier) as! MatchDetailsViewController
        nextViewController.match = self.filteredMatchesList[index!.section][index!.row]
    }
    
    func didTapSaveButton(index: IndexPath?, scoreLeft: Int, scoreRight: Int) {
        let match = self.filteredMatchesList[index!.section][index!.row]
        match.changeGuess(guessScore: Score(leftScore: scoreLeft, rightScore: scoreRight))
        self.view.endEditing(true)
    }
}
