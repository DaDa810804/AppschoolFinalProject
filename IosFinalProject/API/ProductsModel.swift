

import Foundation
//產品
struct Product: Codable {
  let id, baseCurrency, quoteCurrency, quoteIncrement: String
  let baseIncrement, displayName, minMarketFunds: String
  let marginEnabled, postOnly, limitOnly, cancelOnly: Bool
  let status, statusMessage: String
  let tradingDisabled, fxStablecoin: Bool
  let maxSlippagePercentage: String
  let auctionMode: Bool
  let highBidLimitPercentage: String
//    id：产品的唯一标识符。
//    baseCurrency：产品的基础货币。
//    quoteCurrency：产品的报价货币。
//    quoteIncrement：报价的增量。
//    baseIncrement：基础货币的增量。
//    displayName：产品的显示名称。
//    minMarketFunds：最小市场资金。
//    marginEnabled：指示产品是否启用杠杆功能的布尔值。
//    postOnly：指示产品是否仅限挂单的布尔值。
//    limitOnly：指示产品是否仅限限价单的布尔值。
//    cancelOnly：指示产品是否仅限取消订单的布尔值。
//    status：产品的状态。
//    statusMessage：状态消息。
//    tradingDisabled：指示产品是否禁止交易的布尔值。
//    fxStablecoin：指示产品是否为外汇稳定币的布尔值。
//    maxSlippagePercentage：最大滑点百分比。
//    auctionMode：指示产品是否处于拍卖模式的布尔值。
//    highBidLimitPercentage：最高竞标限制百分比。
  enum CodingKeys: String, CodingKey {
    case id
    case baseCurrency = "base_currency"
    case quoteCurrency = "quote_currency"
    case quoteIncrement = "quote_increment"
    case baseIncrement = "base_increment"
    case displayName = "display_name"
    case minMarketFunds = "min_market_funds"
    case marginEnabled = "margin_enabled"
    case postOnly = "post_only"
    case limitOnly = "limit_only"
    case cancelOnly = "cancel_only"
    case status
    case statusMessage = "status_message"
    case tradingDisabled = "trading_disabled"
    case fxStablecoin = "fx_stablecoin"
    case maxSlippagePercentage = "max_slippage_percentage"
    case auctionMode = "auction_mode"
    case highBidLimitPercentage = "high_bid_limit_percentage"
  }
}
