//
//  Team.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 28/4/22.
//

import Foundation


class Team : Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.name == rhs.name
    }
    
    private let name: String
    private let image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getImage() -> String {
        return self.image
    }
}
