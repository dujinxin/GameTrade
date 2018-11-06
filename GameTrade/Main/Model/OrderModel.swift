//
//  OrderModel.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderModel: BaseModel {
    
}
class OrderListEntity: BaseModel {
    @objc var total : Int = 0
    @objc var listArray = Array<OrderEntity>()
}

class OrderEntity: BaseModel {
    @objc var id : String = ""
    @objc var salerId : String?
    @objc var buyerId : String?
    @objc var coinPrice : Double = 0
    @objc var coinCounts : Int = 0
    @objc var totalAmount : Double = 0
    @objc var payAmount : Double = 0
    @objc var payType : Int = 0
    @objc var orderStatus : Int = 0 //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
    @objc var orderType : String?
    @objc var createTime : String?
    @objc var expireTime : Int = -1 //过期时间计时（秒），当orderStatus为1时才有此字段,买单
    @objc var receiveExpireTime : Int = -1 //过期时间计时（秒），当orderStatus为2时才有此字段，卖单
    
    
}
class OrderDetailEntity: OrderEntity {
    @objc var orderNum : String?
    @objc var agentName : String?
    @objc var account : String?
    @objc var discount : Double = 0
    @objc var name : String?
    @objc var qrcodeImg : String?
    @objc var payTime : String?
    @objc var orderCipher : String?
    @objc var bank : String?
    @objc var agentHeadImg : String?
    
}

