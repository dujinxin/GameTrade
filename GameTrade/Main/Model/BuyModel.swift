
//
//  TradeModel.swift
//  Star
//
//  Created by 杜进新 on 2018/7/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class BuyListEntity: BaseModel {
    @objc var total : Int = 0
    @objc var listArray = Array<BuyEntity>()
}
class BuyPayTypeEntity: BaseModel {
    var listArray = Array<Int>()
}
class BuyEntity: BaseModel {
    @objc var id : String?
    @objc var agentId : String?
    @objc var type : Int = 0
    @objc var limitMin : Int = 0
    @objc var limitMax : Int = 0
    @objc var payType : Int = 0
    @objc var agentEntity = AgentEntity()
}

class AgentEntity: BaseModel {
    @objc var id : String?
    @objc var nickname : String?
    @objc var headImg : String?
    @objc var tradeCounts : Int = 0
    @objc var tradeSuccCounts : Int = 0//
}

