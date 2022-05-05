//
//  Match.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 28/4/22.
//

import Foundation

struct Score: Equatable {
    var leftScore : Int = 0
    var rightScore : Int = 0
}

enum MatchStatus {
    case pending, correct, missed, noResult

    var text : String {
      switch self {
      case .pending: return "Pendiente"
      case .correct: return "Acertado"
      case .missed: return "Errado"
      case .noResult: return "No jugado"
      }
    }
}

class Match {
    let teamLeft: Team
    let teamRight: Team
    private(set) var score: Score?
    private(set) var guess: Score?
    private(set) var date: Date
    
    init(teamLeft: Team, teamRight: Team, date: Date, score: Score? = nil, guess: Score? = nil){
        self.teamLeft = teamLeft
        self.teamRight = teamRight
        self.score = score
        self.guess = guess
        self.date = date
    }
    
    public func getMatchPlayed() -> Bool {
        return self.date >= Date() || self.score != nil
    }
    
    public func getMatchStatus() -> MatchStatus {
        if (self.getMatchPlayed()){
            if(self.guess==nil){
                return MatchStatus.noResult
            }
            
            if(self.score == self.guess){
                return MatchStatus.correct
            }
            return MatchStatus.missed
        }
        return MatchStatus.pending
    }
    
    public func changeGuess(guessScore: Score){
        if !self.getMatchPlayed() {
            self.guess = guessScore
        }
    }
    
}
