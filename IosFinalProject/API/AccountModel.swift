//
//  AccountModel.swift
//  DoubleCoin
//
//  Created by 姜權芳 on 2023/6/28.
//

import Foundation

//帳戶
struct Account: Codable {
  let id: String
  let currency: String
  let balance: String
  let hold: String
  let available: String
  let profileId: String
  let tradingEnabled: Bool
//    id：账户的唯一标识符。
//    currency：账户的货币类型。
//    balance：账户的余额。
//    hold：账户中被冻结的金额。
//    available：账户中可用的金额。
//    profileId：账户所属的配置文件标识符。
//    tradingEnabled：指示账户是否启用交易功能的布尔值
  enum CodingKeys: String, CodingKey {
    case id
    case currency
    case balance
    case hold
    case available
    case profileId = "profile_id"
    case tradingEnabled = "trading_enabled"
  }
}
