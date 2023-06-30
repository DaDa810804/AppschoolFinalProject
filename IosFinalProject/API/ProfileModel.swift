//
//  ProfileModel.swift
//  DoubleCoin
//
//  Created by 姜權芳 on 2023/6/28.
//

import Foundation

struct Profile: Codable {
  let id: String
  let userId: String
  let name: String
  let active: Bool
  let isDefault: Bool
  let createdAt: String
//    Profile 结构体是用户配置文件的模型，包含了配置文件的唯一标识 id、关联的用户ID userId、名称 name、激活状态 active、是否默认配置 isDefault 和创建时间 createdAt。
  enum CodingKeys: String, CodingKey {
    case id
    case userId = "user_id"
    case name
    case active
    case isDefault = "is_default"
    case createdAt = "created_at"
  }
}
