//
//  CurrenciesModel.swift
//  DoubleCoin
//
//  Created by 姜權芳 on 2023/6/29.
//

import Foundation

// MARK: - Currencies

//貨幣
struct Currencies: Codable {
  let id, name, minSize: String
  let status: Status
  let message, maxPrecision: String
  let convertibleTo: [String]
  let details: Details
  let defaultNetwork: String
  let supportedNetworks: [SupportedNetwork]
//id: 货币的唯一标识符。
//name: 货币的名称。
//minSize: 货币的最小数量。
//status: 货币的状态。
//message: 关于货币的附加信息。
//maxPrecision: 货币的最大精度。
//convertibleTo: 可以兑换为的其他货币列表。
//details: 货币的详细信息。
//defaultNetwork: 默认网络。
//supportedNetworks: 支持的网络列表。
    
  enum CodingKeys: String, CodingKey {
    case id, name
    case minSize = "min_size"
    case status, message
    case maxPrecision = "max_precision"
    case convertibleTo = "convertible_to"
    case details
    case defaultNetwork = "default_network"
    case supportedNetworks = "supported_networks"
  }
}

// MARK: - Details

//細節
struct Details: Codable {
  let type: TypeEnum
  let symbol: String?
  let networkConfirmations, sortOrder: Int?
  let cryptoAddressLink, cryptoTransactionLink: String?
  let pushPaymentMethods, groupTypes: [String]
  let displayName: String?
  let processingTimeSeconds: JSONNull?
  let minWithdrawalAmount: Double?
  let maxWithdrawalAmount: Int?
//type: 货币的类型。
//symbol: 货币的符号。
//networkConfirmations: 网络确认数量。
//sortOrder: 货币在排序中的顺序。
//cryptoAddressLink: 加密货币地址链接。
//cryptoTransactionLink: 加密货币交易链接。
//pushPaymentMethods: 支持的推送支付方法列表。
//groupTypes: 货币所属的组类型列表。
//displayName: 货币的显示名称。
//processingTimeSeconds: 处理时间（秒）。
//minWithdrawalAmount: 最小提款金额。
//maxWithdrawalAmount: 最大提款金额
  enum CodingKeys: String, CodingKey {
    case type, symbol
    case networkConfirmations = "network_confirmations"
    case sortOrder = "sort_order"
    case cryptoAddressLink = "crypto_address_link"
    case cryptoTransactionLink = "crypto_transaction_link"
    case pushPaymentMethods = "push_payment_methods"
    case groupTypes = "group_types"
    case displayName = "display_name"
    case processingTimeSeconds = "processing_time_seconds"
    case minWithdrawalAmount = "min_withdrawal_amount"
    case maxWithdrawalAmount = "max_withdrawal_amount"
  }
}

//货币的类型
enum TypeEnum: String, Codable {
  case crypto
  case fiat
//    crypto：表示加密货币类型。
//    fiat：表示法定货币类型
}

//货币的状态
enum Status: String, Codable {
  case delisted
  case online
//    delisted：表示货币已下架状态。
//    online：表示货币处于在线状态。
}

// MARK: - SupportedNetwork

//支持的网络信息
struct SupportedNetwork: Codable {
  let id, name: String
  let status: Status
  let contractAddress, cryptoAddressLink, cryptoTransactionLink: String
  let minWithdrawalAmount: Double
  let maxWithdrawalAmount, networkConfirmations: Int
  let processingTimeSeconds: JSONNull?
//    id：网络的唯一标识符。
//    name：网络的名称。
//    status：网络的状态，使用 Status 枚举表示。
//    contractAddress：合约地址。
//    cryptoAddressLink：加密地址的链接。
//    cryptoTransactionLink：加密交易的链接。
//    minWithdrawalAmount：最小提现金额。
//    maxWithdrawalAmount：最大提现金额。
//    networkConfirmations：网络确认数。
//    processingTimeSeconds：处理时间（以秒为单位），可选值。
  enum CodingKeys: String, CodingKey {
    case id, name, status
    case contractAddress = "contract_address"
    case cryptoAddressLink = "crypto_address_link"
    case cryptoTransactionLink = "crypto_transaction_link"
    case minWithdrawalAmount = "min_withdrawal_amount"
    case maxWithdrawalAmount = "max_withdrawal_amount"
    case networkConfirmations = "network_confirmations"
    case processingTimeSeconds = "processing_time_seconds"
  }
}

// MARK: - Encode/decode helpers


//JSONNull 类的作用是在处理 JSON 数据时，为了准确地表示和处理 JSON 中的 null 值而定义的特殊类型。它使得在使用 Swift 的 Codable 协议进行 JSON 编码和解码时能够正确处理空值情况。
class JSONNull: Codable, Hashable {
  public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
    return true
  }

  public var hashValue: Int {
    return 0
  }

  public init() {}

  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}
