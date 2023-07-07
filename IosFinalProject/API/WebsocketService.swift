//
//  CoinbaseService.swift
//  CoinMaster-Sylvia
//
//  Created by Sin on 2023/6/30.
//

import Foundation
import Starscream

struct SubscriptionMessage: Codable {
    let type: String
    let productIds: [String]
    let channels: [String]
}

struct TickerMessage: Codable {
//    let type: String
//    let sequence: Int
//    let productId: String
//    let price: String
//    let open24h: String
//    let volume24h: String
//    let low24h: String
//    let high24h: String
//    let volume30d: String
    let bestBid: String
//    let bestBidSize: String
    let bestAsk: String
//    let bestAskSize: String
//    let side: String
//    let time: String
//    let tradeId: Int
//    let lastSize: String
//type: 類型
//sequence: 序列
//productId: 產品ID
//price: 價格
//open24h: 過去24小時開盤價
//volume24h: 過去24小時交易量
//low24h: 過去24小時最低價
//high24h: 過去24小時最高價
//volume30d: 過去30天交易量
//bestBid: 最佳買價
//bestBidSize: 最佳買價量
//bestAsk: 最佳賣價
//bestAskSize: 最佳賣價量
//side: 交易方向
//time: 時間
//tradeId: 交易ID
//lastSize: 最後成交量
    enum CodingKeys: String, CodingKey {
//        case type
//        case sequence
//        case productId = "product_id"
//        case price
//        case open24h = "open_24h"
//        case volume24h = "volume_24h"
//        case low24h = "low_24h"
//        case high24h = "high_24h"
//        case volume30d = "volume_30d"
        case bestBid = "best_bid"
//        case bestBidSize = "best_bid_size"
        case bestAsk = "best_ask"
//        case bestAskSize = "best_ask_size"
//        case side
//        case time
//        case tradeId = "trade_id"
//        case lastSize = "last_size"
    }
}

class WebsocketService: WebSocketDelegate {
    static let shared = WebsocketService()
    var socket: WebSocket!
    var currency: String?
    var realTimeData: (([String]) -> ())?
    
    func setWebsocket(currency: String) {
        let request = URLRequest(url: URL(string: "wss://ws-feed-public.sandbox.exchange.coinbase.com")!)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        self.currency = currency
    }
    
    func stopSocket() {
        socket.disconnect()
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            // subscribe channel
            guard let currency = currency else { return }
            let subscription =
            """
{
            "type": "subscribe",
            "product_ids": [
                
                "\(currency)"
            ],
            "channels": ["ticker_batch"]
            
        }
"""
            socket.write(string: subscription)
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            if let data = string.data(using: .utf8) {
                    do {
                        let decoder = JSONDecoder()
                        let tickerMessage = try decoder.decode(TickerMessage.self, from: data)
                        let realTimeBid = tickerMessage.bestBid
                        let realTimeAsk = tickerMessage.bestAsk
                        self.realTimeData!([realTimeBid, realTimeAsk])
                    } catch {
                        print("Failed to decode ticker message: \(error)")
                    }
                }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            break
        case .error(let error):
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let error = error as? WSError {
            print("websocket encountered an error: \(error.message)\(error.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
