//
//  Match.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 28/4/22.
//

import Foundation
import UIKit

struct Score: Decodable, Equatable {
    var leftScore : Int = 0
    var rightScore : Int = 0
}

struct MatchLog : Decodable {
    var minute : Int
    var side : String
    var event : String
    var playerName : String
    
    var icon : String {
        switch self.event {
        case "red card": return "redCard"
        case "yellow card": return "yellowCard"
        case "goal": return "goal"
        default: return ""
        }
    }
    
}

enum MatchStatus: String, Decodable {
    case pending, correct, incorrect, notPredicted
    
    var text : String {
        switch self {
        case .pending: return "Pendiente"
        case .correct: return "Acertado"
        case .incorrect: return "Errado"
        case .notPredicted: return "No jugado"
        }
    }
    
    var color : UIColor {
        switch self {
        case .pending: return UIColor(red:25.0/255,green:55.0/255,blue: 163.0/255, alpha: 1.0)
        case .correct: return UIColor(red:0.0/255,green:163.0/255,blue: 98.0/255, alpha: 1.0)
        case .incorrect: return UIColor(red:208.0/255,green:49.0/255,blue: 87.0/255, alpha: 1.0)
        case .notPredicted: return UIColor(red:161.0/255,green:159.0/255,blue: 157.0/255, alpha: 1.0)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case pending, notPredicted = "not_predicted", correct, incorrect
    }
    
    var encoding : String {
        switch self {
        case .notPredicted: return "not_predicted"
        default: return self.rawValue
        }
    }
}

class Match {
    let matchId: Int
    let teamLeft: Team
    let teamRight: Team
    let score: Score?
    private(set) var guess: Score?
    private(set) var date: Date
    private(set) var matchStatus: MatchStatus
    var logs: [MatchLog]
    
    init(matchId: Int, teamLeft: Team, teamRight: Team, matchStatus: MatchStatus, date: Date, score: Score? = nil, guess: Score? = nil, logs: [MatchLog] = []){
        self.matchId = matchId
        self.teamLeft = teamLeft
        self.teamRight = teamRight
        self.score = score
        self.guess = guess
        self.date = date
        self.logs = logs
        self.matchStatus = matchStatus
    }
    
    public func getMatchPlayed() -> Bool {
        return self.matchStatus != MatchStatus.pending
    }
    
    public func changeGuess(guessScore: Score?) -> Bool{
        if !self.getMatchPlayed() {
            self.guess = guessScore
            return true
        }
        return false;
    }
    
}
