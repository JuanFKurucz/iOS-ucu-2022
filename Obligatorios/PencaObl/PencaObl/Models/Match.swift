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
    var time : Int = 0
    var text : String = ""
    var icon : String = ""
    var side : String = ""
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
}

class Match {
    let teamLeft: Team
    let teamRight: Team
    private(set) var score: Score?
    private(set) var guess: Score?
    private(set) var date: Date
    private(set) var logs: [MatchLog]
    var matchStatus: MatchStatus
    
    init(teamLeft: Team, teamRight: Team, matchStatus: MatchStatus, date: Date, score: Score? = nil, guess: Score? = nil, logs: [MatchLog] = []){
        self.teamLeft = teamLeft
        self.teamRight = teamRight
        self.score = score
        self.guess = guess
        self.date = date
        self.logs = logs
        self.matchStatus = matchStatus
    }
    
    public func getMatchPlayed() -> Bool {
        return self.date >= Date() || self.score != nil
    }
    
    public func getMatchStatus() -> MatchStatus {
        return self.matchStatus
    }
    
    public func changeGuess(guessScore: Score){
        if !self.getMatchPlayed() {
            self.guess = guessScore
        }
    }
    
}
