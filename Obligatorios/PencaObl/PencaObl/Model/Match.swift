//
//  Match.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 28/4/22.
//

import Foundation

struct Score: Equatable {
    var leftScore = 0
    var rightScore = 0
}

enum MatchStatus {
  case Pendiente, Acertado, Errado, JugadoSinResultado
}

class Match {
    private let teamLeft: Team
    private let teamRight: Team
    private var matchPlayed: Bool
    private var score: Score?
    private var guess: Score?
    private var date: Date
    
    init(teamLeft: Team, teamRight: Team, date: Date, matchPlayed: Bool = false, score: Score? = nil, guess: Score? = nil){
        self.teamLeft = teamLeft
        self.teamRight = teamRight
        self.matchPlayed = matchPlayed
        self.score = score
        self.guess = guess
        self.date = date
    }
    
    public func getTeamLeft() -> Team {
        return self.teamLeft
    }
    
    public func getTeamRight() -> Team {
        return self.teamRight
    }
    
    public func getMatchPlayed() -> Bool {
        return self.matchPlayed
    }
    
    public func getMatchStatus() -> MatchStatus {
        if (self.getMatchPlayed()){
            if(self.getScore() == self.getGuess()){
                return MatchStatus.Acertado
            }
            return MatchStatus.Errado
        }
        return MatchStatus.Pendiente
    }
    
    public func getScore() -> Score? {
        return self.score
    }
    
    public func getGuess() -> Score? {
        return self.guess
    }
    
    public func getDate() -> Date {
        return self.date
    }
    
    public func changeGuess(guessScore: Score){
        if self.matchPlayed == false {
            self.guess = guessScore
        }
    }
    
}
