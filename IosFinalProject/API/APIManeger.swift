//
//  APIManeger.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/6/28.
//

import Foundation
import CryptoKit

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum ApiUrls {
    static let baseUrl = "https://api-public.sandbox.pro.coinbase.com"
    
    case getProducts
    case getAccounts
    case getUserProfile
    case getProductStats(productId: String)
    case getCurrencies
    case getProductCandles(productId: String)
    
    var urlString: String {
        switch self {
        case .getProducts:
            return ApiUrls.baseUrl + "/products"
        case .getAccounts:
            return ApiUrls.baseUrl + "/accounts"
        case .getUserProfile:
            return ApiUrls.baseUrl + "/profiles?active"
        case .getProductStats(let productId):
            return ApiUrls.baseUrl + "/products/\(productId)/stats"
        case .getCurrencies:
            return ApiUrls.baseUrl + "/currencies"
        case .getProductCandles(let productId):
            return ApiUrls.baseUrl + "/products/\(productId)/candles"
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum TimeRange: String {
    case oneDay = "1d"
    case oneWeek = "1w"
    case oneMonth = "1M"
    case threeMonths = "3M"
    case oneYear = "1y"
    case allData = "all"
    
    var granularity: Int {
        switch self {
        case .oneDay, .oneWeek:
            return 3600 // 1小时
        case .oneMonth, .threeMonths, .oneYear, .allData:
            return 86400 // 1天
        }
    }
}

class ApiManager {
    static let shared = ApiManager()
    //  var semaphore = DispatchSemaphore(value: 0)
    
    //发起网络请求，并通过传递的参数进行配置。它接受 HTTP 方法、URL 字符串、响应类型、请求头等参数，并通过完成处理程序返回结果
    func fetchData<T: Decodable>(httpMethod: String, urlString: String, responseType: T.Type, headers: [String: String]?, completion: @escaping (Result<T, Error>) -> Void) {
        let method = httpMethod
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            //      semaphore.signal()
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        
        if let headers = headers {
            for (field, value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                //        self.semaphore.signal()
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Empty Response Data", code: 0, userInfo: nil)
                completion(.failure(error))
                //        self.semaphore.signal()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(responseType, from: data)
                //        self.semaphore.signal()
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        //    semaphore.wait()
    }
    
    func fetchDataToPost<T: Decodable>(httpMethod: String, urlString: String, responseType: T.Type, headers: [String: String]?,body: String, completion: @escaping (Result<T, Error>) -> Void) {
        let method = httpMethod
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            //      semaphore.signal()
            return
        }
        guard let httpBody = body.data(using: .utf8) else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        request.httpBody = httpBody
        if let headers = headers {
            for (field, value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                //        self.semaphore.signal()
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Empty Response Data", code: 0, userInfo: nil)
                completion(.failure(error))
                //        self.semaphore.signal()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(responseType, from: data)
                //        self.semaphore.signal()
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        //    semaphore.wait()
    }
    
    func creatOrder(size: String, side: String, productId: String, completion: @escaping(Order?) -> Void) {
        let baseUrl = "https://api-public.sandbox.pro.coinbase.com"
        let orderPath = "/orders"
        let requestPath = baseUrl + orderPath
        let body = "{\"type\": \"market\", \"size\": \"\(size)\", \"side\": \"\(side)\", \"product_id\":\"\(productId)\", \"time_in_force\": \"FOK\"}"
        let headers = CoinbaseService.shared.createHeadersForPost(requestPath: orderPath, body: body)
        fetchDataToPost(httpMethod: "POST", urlString: requestPath, responseType: Order.self, headers: headers, body: body) { result in
            switch result {
            case .success(let order):
                completion(order)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    //獲取產品資訊
    func getProducts(completion: @escaping ([String]) -> Void) {
        let accountsUrl = ApiUrls.getProducts.urlString
        var coinArray: [String] = []
        
        fetchData(httpMethod: "GET", urlString: accountsUrl, responseType: [Product].self, headers: nil) { result in
            switch result {
            case .success(let allProducts):
                coinArray = allProducts.filter { $0.quoteCurrency == "USD" && !$0.auctionMode }.map { $0.id }
                let sortedStrings = sortStringsByFirstLetter(strings: coinArray)
                completion(sortedStrings)
                //        completion(coinArray)
                //        print(allProducts)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    //获取账户列表。它发起一个 GET 请求，获取所有账户
    func getAccounts(completion: @escaping ([Account]) -> Void) {
        let accountsUrl = ApiUrls.getAccounts.urlString
        let headers = CoinbaseService.shared.createHeaders(requestPath: "/accounts")
        
        fetchData(httpMethod: "GET", urlString: accountsUrl, responseType: [Account].self, headers: headers) { result in
            switch result {
            case .success(let allAccounts):
                completion(allAccounts)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    //获取用户资料
    func getUserProfile(completion: @escaping ([Profile]) -> Void) {
        let userProfileUrl = ApiUrls.getUserProfile.urlString
        let headers = CoinbaseService.shared.createHeaders(requestPath: "/profiles?active")
        
        fetchData(httpMethod: "GET", urlString: userProfileUrl, responseType: [Profile].self, headers: headers) { result in
            switch result {
            case .success(let profile):
                completion(profile)
                print(profile)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    //获取特定产品的统计信息
    func getProductsStats(productId: String, completion: @escaping (ProductStat?) -> Void) {
        let productUrl = ApiUrls.getProductStats(productId: productId).urlString
        //    var semaphore = DispatchSemaphore(value: 0)
        
        fetchData(httpMethod: "GET", urlString: productUrl, responseType: ProductStat.self, headers: nil) { result in
            switch result {
            case .success(let productStat):
                completion(productStat)
                //        print(productStat)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
            //      semaphore.signal()
        }
        //    semaphore.wait()
    }
    
    //获取货币列表
    func getCurrencies() {
        let currenciesUrl = ApiUrls.getCurrencies.urlString
        
        fetchData(httpMethod: "GET", urlString: currenciesUrl, responseType: [Currencies].self, headers: nil) { result in
            switch result {
            case .success(let currencies):
                print("currenciescurrencies\(currencies)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    //获取特定产品的蜡烛图数据
    func getProductCandles(productId: String) {
        let productCandlesUrl = ApiUrls.getProductCandles(productId: productId).urlString
        
        fetchData(httpMethod: "GET", urlString: productCandlesUrl,
                  responseType: [CandlesJSON].self, headers: nil)
        { result in
            switch result {
            case .success(let productCandles):
                print(productCandles)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func fetchCandleData(productID: String, timeRange: TimeRange, completion: @escaping ([Candles]?, Error?) -> Void) {
        let baseURL = "https://api-public.sandbox.exchange.coinbase.com"
        var requestURLString = "\(baseURL)/products/\(productID)/candles?granularity=\(timeRange.granularity)"
        
        if timeRange != .allData {
            // 计算开始时间和结束时间
            let endDate = Date()
            var startDate: Date
            
            switch timeRange {
            case .oneDay:
                startDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
            case .oneWeek:
                startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: endDate)!
            case .oneMonth:
                startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
            case .threeMonths:
                startDate = Calendar.current.date(byAdding: .month, value: -3, to: endDate)!
            case .oneYear:
                startDate = Calendar.current.date(byAdding: .year, value: -1, to: endDate)!
            default:
                startDate = Date() // 默认为当前时间
            }
            
            // 格式化时间字符串
            let dateFormatter = ISO8601DateFormatter()
            let startTimeString = dateFormatter.string(from: startDate)
            let endTimeString = dateFormatter.string(from: endDate)
            
            // 拼接请求 URL
            requestURLString += "&start=\(startTimeString)&end=\(endTimeString)"
        }
        
        guard let requestURL = URL(string: requestURLString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                // 解析 JSON 数据
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]]
                var candlesArray: [Candles] = []
                if let jsonArray = json {
                    for item in jsonArray {
                        if let time = item[0] as? Double,
                           let low = item[1] as? Double,
                           let high = item[2] as? Double,
                           let open = item[3] as? Double,
                           let close = item[4] as? Double,
                           let volume = item[5] as? Double {
                            let candles = Candles(time: time, low: low, high: high, open: open, close: close, volume: volume)
                            candlesArray.append(candles)
                        }
                    }
                }
                
                completion(candlesArray, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
    func fetchCandleYearData(productID: String, timeRange: TimeRange, completion: @escaping ([Candles]?, Error?) -> Void) {
        let baseURL = "https://api-public.sandbox.exchange.coinbase.com"
        var requestURLString = "\(baseURL)/products/\(productID)/candles?granularity=\(timeRange.granularity)"
        
        if timeRange != .allData {
            var candlesArray: [Candles] = []
            var endDate = Date()
            let dispatchGroup = DispatchGroup()
            // 迴圈執行四次，每次呼叫三個月的 API
            for _ in 1...4 {
                let startDate = Calendar.current.date(byAdding: .month, value: -3, to: endDate)!
                let dateFormatter = ISO8601DateFormatter()
                let startTimeString = dateFormatter.string(from: startDate)
                let endTimeString = dateFormatter.string(from: endDate)
                
                // 拼接請求 URL
                let requestURLStringWithDates = "\(requestURLString)&start=\(startTimeString)&end=\(endTimeString)"
                
                guard let requestURL = URL(string: requestURLStringWithDates) else {
                    completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                    return
                }
                
                dispatchGroup.enter()
                
                let session = URLSession.shared
                let task = session.dataTask(with: requestURL) { (data, response, error) in
                    
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    guard let data = data else {
                        completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                        return
                    }
                    
                    do {
                        // 解析 JSON 資料
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]]
                        if let jsonArray = json {
                            for item in jsonArray {
                                if let time = item[0] as? Double,
                                   let low = item[1] as? Double,
                                   let high = item[2] as? Double,
                                   let open = item[3] as? Double,
                                   let close = item[4] as? Double,
                                   let volume = item[5] as? Double {
                                    let candles = Candles(time: time, low: low, high: high, open: open, close: close, volume: volume)
                                    candlesArray.append(candles)
                                }
                            }
                        }
                    } catch {
                        completion(nil, error)
                    }
                }
                
                task.resume()
                
                // 更新起始日期和結束日期
                endDate = startDate
            }
            
            dispatchGroup.notify(queue: .main) {
                // 對陣列進行排序
                let sortedCandlesArray = candlesArray.sorted(by: { $0.time < $1.time })
                completion(sortedCandlesArray, nil)
            }
        }
    }
    
    func fetchAllCandleData(productID: String, completion: @escaping ([Candles]?, Error?) -> Void) {
        let baseURL = "https://api-public.sandbox.exchange.coinbase.com"
        let requestURLString = "\(baseURL)/products/\(productID)/candles?granularity=86400"
        
        var allCandlesArray: [Candles] = []
        var date = Date()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        
        var tempCandles: [Candles] = []
        repeat {
            let threeHundredDaysAgo = Calendar.current.date(byAdding: .day, value: -300, to: date)!
            tempCandles = []
            let startDateString = String(Int(threeHundredDaysAgo.timeIntervalSince1970))
            let endDateString = String(Int(date.timeIntervalSince1970))
            
            let requestURLStringWithDates = "\(requestURLString)&start=\(startDateString)&end=\(endDateString)"
            
            guard let requestURL = URL(string: requestURLStringWithDates) else {
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }
            
            
            
            
            let session = URLSession.shared
            let task = session.dataTask(with: requestURL) { (data, response, error) in
                defer {
                    semaphore.signal()
                }
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                    return
                }
                
                do {
                    // Parse JSON data
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]] {
                        for item in jsonArray {
                            if let time = item[0] as? Double,
                               let low = item[1] as? Double,
                               let high = item[2] as? Double,
                               let open = item[3] as? Double,
                               let close = item[4] as? Double,
                               let volume = item[5] as? Double {
                                let candles = Candles(time: time, low: low, high: high, open: open, close: close, volume: volume)
                                allCandlesArray.append(candles)
                                tempCandles.append(candles)
                            }
                        }
                    }
                    //                    completion(allCandlesArray, nil)
                } catch {
                    completion(nil, error)
                }
            }
            
            task.resume()
            
            date = threeHundredDaysAgo
            semaphore.wait()
        } while tempCandles.count != 0
        completion(allCandlesArray, nil)
    }
    
    func getOneHundredOrders(completion: @escaping ([Order]?) -> Void){
        let test = "/orders?limit=100&status=done"
        let productCandlesUrl = "https://api-public.sandbox.pro.coinbase.com\(test)"
        let headers = CoinbaseService.shared.createHeaders(
            requestPath: test)
        
        fetchData(httpMethod: "GET", urlString: productCandlesUrl, responseType: [Order].self, headers: headers) { result in
            switch result {
            case .success(let allOrders):
                print(allOrders)
                completion(allOrders)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    func getOrders(productId: String, completion: @escaping ([Order]?) -> Void){
        let test = "/orders?limit=5&status=done&product_id=\(productId)"
        let productCandlesUrl = "https://api-public.sandbox.pro.coinbase.com\(test)"
        let headers = CoinbaseService.shared.createHeaders(
            requestPath: test)
        
        fetchData(httpMethod: "GET", urlString: productCandlesUrl, responseType: [Order].self, headers: headers) { result in
            switch result {
            case .success(let allOrders):
                print(allOrders)
                completion(allOrders)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    func getOrderForId(id: String, completion: @escaping (Order?) -> Void){
        let test = "/orders/\(id)"
        let productCandlesUrl = "https://api-public.sandbox.pro.coinbase.com\(test)"
        let headers = CoinbaseService.shared.createHeaders(
            requestPath: test)
        
        fetchData(httpMethod: "GET", urlString: productCandlesUrl, responseType: Order.self, headers: headers) { result in
            switch result {
            case .success(let order):
                print(order)
                completion(order)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}

//用于生成身份验证所需的签名和请求头信息
class CoinbaseService {
    static let shared = CoinbaseService()

    
    //用于生成时间戳和签名
    func getTimestampSignature(requestPath: String,
                               method: String,
                               body: String) -> (String, String)
    {
        let date = Date().timeIntervalSince1970
        let cbAccessTimestamp = String(date)
        let secret = secret
        let requestPath = requestPath
        let body = body
        let method = method
        let message = "\(cbAccessTimestamp)\(method)\(requestPath)\(body)"
        
        guard let keyData = Data(base64Encoded: secret) else {
            fatalError("Failed to decode secret as base64")
        }
        
        let hmac = HMAC<SHA256>.authenticationCode(for: Data(message.utf8), using: SymmetricKey(data: keyData))
        
        let cbAccessSign = hmac.withUnsafeBytes { macBytes -> String in
            let data = Data(macBytes)
            return data.base64EncodedString()
        }
        
        return (cbAccessSign, cbAccessTimestamp)
    }
    
    //用于创建请求头信息。它使用 API 密钥、密钥短语和时间戳签名，返回一个包含身份验证信息的请求头字典
    func createHeaders(requestPath: String) -> [String: String] {
        let apiKey = api
        let passphrase = passphrase
        let timestampSignature = CoinbaseService.shared.getTimestampSignature(requestPath: requestPath,
                                                                              method: HttpMethod.get.rawValue,
                                                                              body: "")
        
        return [
            "cb-access-key": apiKey,
            "cb-access-passphrase": passphrase,
            "cb-access-sign": timestampSignature.0,
            "cb-access-timestamp": timestampSignature.1
        ]
    }
    
    func createHeadersForPost(requestPath: String, body: String) -> [String: String] {
        let apiKey = api
        let passphrase = passphrase
        let timestampSignature = CoinbaseService.shared.getTimestampSignature(requestPath: requestPath,
                                                                              method: HttpMethod.post.rawValue,
                                                                              body: body)
        
        return [
            "cb-access-key": apiKey,
            "cb-access-passphrase": passphrase,
            "cb-access-sign": timestampSignature.0,
            "cb-access-timestamp": timestampSignature.1
        ]
    }
}
