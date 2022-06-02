//
//  Visual.swift
//  PencaObl
//
//  Created by Juan Francisco Kurucz on 7/5/22.
//
import Foundation


class Validation {
    static func scoreValidation(number: String) -> String {
        let scoreNumber = Int(number) ?? -1
        
        if scoreNumber > 99 || scoreNumber < 0 {
            return ""
        }
        return String(scoreNumber)
    }
}
