//
//  TextManipulation.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 4/7/22.
//

import Foundation



class TextManipulation {
    
    static func dateToText(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter.string(from: date)
    }
}
