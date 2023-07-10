//
//  FucnAdd.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/2.
//

import Foundation
import Starscream

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

func timeChange(dateString: String) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    if let date = dateFormatter.date(from: dateString) {
        let targetTimeZone = TimeZone(identifier: "UTC") // 源时区
        let targetFormatter = DateFormatter()
        targetFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        targetFormatter.timeZone = targetTimeZone
        let targetDate = date.addingTimeInterval(8 * 60 * 60)
        let formattedDate = targetFormatter.string(from: targetDate)
        return formattedDate
        print(formattedDate)
    } else {
        // 解析失败
        print("日期解析失败")
        return ""
    }
}

func truncateDoubleToString(_ value: Double) -> String {
    let stringValue = String(value)
    if stringValue.count > 8 {
        let index = stringValue.index(stringValue.startIndex, offsetBy: 8)
        return String(stringValue[..<index])
    }
    return stringValue
}


