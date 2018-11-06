//
//  TaskModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/6.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class PayListEntity: BaseModel {
    @objc var list = Dictionary<String, PayEntity>()
    
    override init() {
        for i in 1..<4 {
            let entity = PayEntity()
            entity.type = i
            if entity.type == 1 {
                list["ali"] = entity
            } else if entity.type == 2 {
                list["weChat"] = entity
            } else {
                list["card"] = entity
            }
        }
    }
}
class PayEntity: BaseModel {
    
    @objc var isEmpty : Int = 1
    
    
    @objc var id : String?
    @objc var type : Int = 1
    @objc var name : String?
    @objc var bank : String?
    @objc var account : String?
    @objc var accountType : String?
    @objc var qrcodeImg : String?
}

class BankListEntity: BaseModel {
    @objc var list = Array<BankEntity>()
}
class BankEntity: BaseModel {
    @objc var id : Int = 0
    @objc var pinyin : String?
    @objc var name : String?
    @objc var isCommon : Int = 1 //1常用，2非
}
