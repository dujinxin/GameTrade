//
//  WalletModel.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/23.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import BigInt

class TradeListEntity: BaseModel {
    @objc var total : Int = 0
    @objc var listArray = Array<TradeEntity>()
}
class TradeEntity: BaseModel {
    @objc var id : String?
    @objc var type : Int = 0 //1:买币，2:卖币，3:支付，4:收款，5:转账，6:手续费，当type为6时不可查看详情
    @objc var amount : Int = 0
    @objc var bizId : String?
    //@objc var remark : String?
    @objc var createTime : String?
    @objc var webName : String?
    
}
class TradeDetailEntity: BaseModel {
    @objc var account : String?
    @objc var price : Double = 0
    @objc var amount : Double = 0
   
    @objc var type : Int = 0
    @objc var typeName : String?
    @objc var createTime : String?
    @objc var webName : String?
    @objc var orderNumber : String?
    @objc var qrCode : String?
    
}
