//
//  SellModel.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/3.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class SellListEntity: BaseModel {
    @objc var total : Int = 0
    @objc var listArray = Array<SellEntity>()
}

class SellEntity: BaseModel {
    
    @objc var id : String?
    @objc var type : Int = 1 //1：平台挂单，2：用户挂单
    @objc var tradeSaleStatus : Int = 1 //用户挂单交易状态，1未交易，2已经交易
    @objc var total : Int = 0 //挂单总数，含手续费
    @objc var rateTotal : Double = 0 //手续费数量
    @objc var realTotal : Double = 0 //实际挂单数，不含手续费
    @objc var payType : Int = 0 //支付类型，1支付宝，2微信，3银行卡
    @objc var createTime : String?

}

class MerchantEntity: BaseModel {
    
    @objc var id : String?
    @objc var nickname : String?
    @objc var headImg : String?
    @objc var tradeCounts : Int = 0
    @objc var tradeSuccCounts : Int = 0
    
    @objc var listArray = Array<MerchantOrderEntity>()
}
class MerchantOrderEntity: BaseModel {
    
    @objc var id : String?
    @objc var limitMin : Int = 1
    @objc var limitMax : Int = 0
    @objc var payType : Int = 1
  
}
class SellInfoEntity: BaseModel {
    @objc var balance : Double = 0
    @objc var saleRate : Double = 0
    
    @objc var list = Array<PayEntity>()
}
