//
//  Database.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 5/5/22.
//

import Foundation


struct ResponseData: Decodable {
    var teams: [TeamData]
    var matches: [MatchData]
}

struct TeamData : Decodable {
    var name: String
    var image: String
}

struct MatchData : Decodable {
    var teamLeft: String
    var teamRight: String
    var date: String
    var score: ScoreData
    var guess: ScoreData
}

struct ScoreData : Decodable{
    var leftScore: Int
    var rightScore: Int
}

class Database {
    static public var teams : [Team] = [];
    static public var matches : [Match] = [];
    
    static public func loadData(jsonPath: String) {
        
        if let url = Bundle.main.url(forResource: jsonPath, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                
                for element in jsonData.teams {
                    Database.teams.append(Team(name: element.name, image: element.image))
                }
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                for element in jsonData.matches {
                    let teamLeft : [Team] = Database.teams.filter({$0.name == element.teamLeft})
                    let teamRight : [Team] = Database.teams.filter({$0.name == element.teamRight})
                    
                    var score: Score? = nil
                    if element.score.leftScore != -1 && element.score.rightScore != -1 {
                        score = Score(leftScore: element.score.leftScore, rightScore: element.score.rightScore)
                    }
                    var guess: Score? = nil
                    if element.guess.leftScore != -1 && element.guess.rightScore != -1 {
                        guess = Score(leftScore: element.guess.leftScore, rightScore: element.guess.rightScore)
                    }
                    Database.matches.append(Match(teamLeft: teamLeft[teamLeft.startIndex], teamRight: teamRight[teamRight.startIndex], date: dateFormatterGet.date(from:element.date)!, score: score, guess: guess))
                }
                Database.matches = Database.matches.sorted(by: {$0.date > $1.date})
            } catch {
                print("error:\(error)")
            }
        }
    }
}
