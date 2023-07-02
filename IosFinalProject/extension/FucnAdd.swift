//
//  FucnAdd.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/2.
//

import Foundation

func sortStringsByFirstLetter(strings: [String]) -> [String] {
    
    let sortedArray = strings.sorted { (string1, string2) -> Bool in
        guard let firstLetter1 = string1.first?.lowercased(),
              let firstLetter2 = string2.first?.lowercased() else {
            return false
        }
        
        return firstLetter1 < firstLetter2
    }
    
    return sortedArray
}




