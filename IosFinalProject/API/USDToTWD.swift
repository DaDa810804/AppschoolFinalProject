//
//  USDToTWD.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/2.
//

import Foundation

struct ExchangeRateData: Codable {
    let data: ExchangeRate
}

struct ExchangeRate: Codable {
    let currency: String
    let rates: [String: String]
}

func getExchangeRate(completion: @escaping (Double?) -> Void) {
    let url = "https://api.coinbase.com/v2/exchange-rates?currency=USD"
    guard let url = URL(string: url) else {
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            completion(nil)
            return
        }
        
        do {
            let exchangeRateData = try JSONDecoder().decode(ExchangeRateData.self, from: data)
            guard let twdRate = exchangeRateData.data.rates["TWD"],
                  let exchangeRate = Double(twdRate) else {
                completion(nil)
                return
            }
            
            completion(exchangeRate)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }
    
    task.resume()
}

func getExchangeRateToCurrency(currency: String, completion: @escaping (Double?) -> Void) {
    let url = "https://api.coinbase.com/v2/exchange-rates?currency=\(currency)"
    guard let url = URL(string: url) else {
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(nil)
            return
        }

        guard let data = data else {
            completion(nil)
            return
        }

        do {
            let exchangeRateData = try JSONDecoder().decode(ExchangeRateData.self, from: data)
            guard let twdRate = exchangeRateData.data.rates["TWD"],
                  let exchangeRate = Double(twdRate) else {
                completion(nil)
                return
            }

            completion(exchangeRate)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }

    task.resume()
}
