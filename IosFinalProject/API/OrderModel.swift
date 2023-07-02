//
//  OrderModel.swift
//  IosFinalProject
//
//  Created by 蔡顯達 on 2023/7/1.
//

import Foundation

struct Order: Codable {
  let id, price, size, productID: String
  let profileID, side, type, timeInForce: String
  let createdAt, doneAt, doneReason: String
  let fillFees, filledSize, executedValue, marketType: String
  let status: String
  let fundingCurrency: String?
  let postOnly, settled: Bool
//id: 訂單的唯一識別碼
//price: 訂單的價格
//size: 訂單的數量或大小
//productID: 產品的識別碼
//profileID: 使用者檔案的識別碼
//side: 買入或賣出的方向
//type: 訂單的類型
//timeInForce: 訂單有效期限
//postOnly: 是否僅限掛單，即不接受市價交易
//createdAt: 訂單的建立時間
//doneAt: 訂單完成時間
//doneReason: 訂單完成的原因
//fillFees: 成交手續費
//filledSize: 已成交的數量
//executedValue: 成交價值
//marketType: 市場類型
//status: 訂單的狀態
//settled: 訂單是否已結算
//fundingCurrency: 資金幣種

  enum CodingKeys: String, CodingKey {
    case id, price, size
    case productID = "product_id"
    case profileID = "profile_id"
    case side, type
    case timeInForce = "time_in_force"
    case postOnly = "post_only"
    case createdAt = "created_at"
    case doneAt = "done_at"
    case doneReason = "done_reason"
    case fillFees = "fill_fees"
    case filledSize = "filled_size"
    case executedValue = "executed_value"
    case marketType = "market_type"
    case status, settled
    case fundingCurrency = "funding_currency"
  }
}

