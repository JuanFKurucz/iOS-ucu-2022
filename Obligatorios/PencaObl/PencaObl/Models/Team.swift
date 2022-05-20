//
//  Team.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 28/4/22.
//

import Foundation
import UIKit


class Team {
    let id: Int
    let name: String
    let image: UIImage?
    
    init(id:Int, name: String, imageURL: String){
        self.id = id
        self.name = name
        self.image = Visual.loadExternalImage(imageURL: "https://\(imageURL)")
    }
}
