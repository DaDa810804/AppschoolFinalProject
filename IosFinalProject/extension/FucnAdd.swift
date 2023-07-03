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
        
        let formattedDate = targetFormatter.string(from: date)
        return formattedDate
        print(formattedDate)
    } else {
        // 解析失败
        print("日期解析失败")
        return ""
    }
}


// Custom WebSocket delegate
//class CustomWebSocketDelegate: WebSocketDelegate {
//    func didReceive(event: WebSocketEvent, client: WebSocket) {
//        switch event {
//        case .connected:
//            print("WebSocket connected")
//
//            // Subscribe to ticker_batch channel every 5 seconds
//            let subscribeMessage = """
//            {
//                "type": "subscribe",
//                "channel": "ticker_batch",
//                "product_ids": ["BTC-USD"],
//                "signature": "\(CoinbaseService.shared.getTimestampSignature(requestPath: "/subscribe", method: "GET", body: "").0)",
//                "api_key": "\(CoinbaseService.shared.api)",
//                "timestamp": "\(CoinbaseService.shared.getTimestampSignature(requestPath: "/subscribe", method: "GET", body: "").1)"
//            }
//            """
//
//            client.write(string: subscribeMessage)
//
//        case .disconnected(let reason, let code):
//            print("WebSocket disconnected: \(reason) (code: \(code))")
//
//        case .text(let message):
//            print("Received message: \(message)")
//
//        case .error(let error):
//            print("WebSocket error: \(error?.localizedDescription ?? "")")
//
//        default:
//            break
//        }
//    }
//}
