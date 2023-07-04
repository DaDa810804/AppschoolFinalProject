//
//  AllDataAPI.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/4.
//

//import Foundation
//
//let calendar = Calendar.current
//var date = Date()
//
//var array = [[Double]]()
//var candlesTemp = [[Double]]()
//var index: Int = 0
//
//let semaphore = DispatchSemaphore(value: 0)
//repeat {
//    let threeHundredDaysAgo = calendar.date(byAdding: .day, value: -300, to: date)!
//    
//    print("---------------------")
//    print("Start = (threeHundredDaysAgo)")
//    print("End = (date)")
//    
//    fetchProductCandles(productID: currencyPair?.id ?? "", granularity: "86400", start: "(Int(threeHundredDaysAgo.timeIntervalSince1970))", end: "(Int(date.timeIntervalSince1970))") { candles in
//        candlesTemp = candles
//        
//        array += candlesTemp
//        date = threeHundredDaysAgo
//        index += 1
//        
//        semaphore.signal()
//        print("第(index)趟完成")
//    }
//    
//    semaphore.wait()
//    
//    print(array.count)
//    print(candlesTemp.count)
//    print("---------------------")
//} while(candlesTemp.count != 0)
//
//print(array.count)
