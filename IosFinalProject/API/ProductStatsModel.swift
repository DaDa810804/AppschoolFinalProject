//
//  ProductStatsModel.swift
//  DoubleCoin
//
//  Created by 姜權芳 on 2023/6/29.
//

import Foundation
import UIKit

// MARK: - Welcome

// 产品统计信息的结构体
struct ProductStat: Codable {
  let open, high, low, last: String
  let volume, volume30Day: String?
//    open: 代表過去 24 小時的開盤價格。
//    high: 代表過去 24 小時的最高價格。
//    low: 代表過去 24 小時的最低價格。
//    last: 代表過去 24 小時的最新成交價格。
//    volume: 代表過去 24 小時的交易量。
//    volume30Day: 代表過去 30 天的交易量。
  enum CodingKeys: String, CodingKey {
    case high, low, last, volume, open
    case volume30Day = "volume_30day"
  }
}

// 产品统计信息的表格模型
struct ProductTableStat {
  let name: String
  let productStat: ProductStat
}

// 产品信息的枚举
enum ProductInfo {
  case bitcoin
  case tether
  case bitcoinCash
  case link

    // 产品名称
  var name: String {
    switch self {
    case .bitcoin:
      return "BTC"
    case .tether:
      return "USDT"
    case .bitcoinCash:
      return "BCH"
    case .link:
      return "LINK"
    }
  }

    // 产品中文名称

  var chtName: String {
    switch self {
    case .bitcoin:
      return "比特幣"
    case .tether:
      return "泰達幣"
    case .bitcoinCash:
      return "比特幣現金"
    case .link:
      return "Chainlink"
    }
  }

//     产品图像
  var image: UIImage? {
    switch self {
    case .bitcoin:
      return UIImage(named: "btc")
    case .tether:
      return UIImage(named: "usdt")
    case .bitcoinCash:
      return UIImage(named: "bch")
    case .link:
      return UIImage(named: "link")
    }
  }

    // 根据表格模型的名称返回对应的产品信息
  static func fromTableStatName(_ name: String) -> ProductInfo? {
    if name == "BTC-USD" {
      return .bitcoin
    } else if name == "USDT-USD" {
      return .tether
    } else if name == "BCH-USD" {
      return .bitcoinCash
    } else if name == "LINK-USD" {
      return .link
    } else {
      return nil
    }
  }
}
