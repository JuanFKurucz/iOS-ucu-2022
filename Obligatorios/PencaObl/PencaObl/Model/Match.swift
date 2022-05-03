//
//  Match.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 28/4/22.
//

import Foundation

class Match {
    private let teamLeft: Team
    private let teamRight: Team
    private var matchPlayed: Bool
    private var guessWinTeam: Team?
    private var date: Date
    
    init(teamLeft: Team, teamRight: Team, date: Date, matchPlayed: Bool = false, guessWinTeam: Team? = nil){
        self.teamLeft = teamLeft
        self.teamRight = teamRight
        self.matchPlayed = matchPlayed
        self.guessWinTeam = guessWinTeam
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
    
    public func getGuessWinTeam() -> Team? {
        return self.guessWinTeam
    }
    
    public func getDate() -> Date {
        return self.date
    }
    
    public func changeGuess(guessedTeam: Team){
        if self.matchPlayed == false {
            if [self.teamLeft, self.teamRight].contains(guessedTeam) {
                self.guessWinTeam = guessedTeam
            }
        }
    }
    
}
