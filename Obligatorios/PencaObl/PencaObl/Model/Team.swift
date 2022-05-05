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
    
    let name: String
    let image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
    
}
