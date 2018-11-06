//
//  HomeModel.swift
//  Star
//
//  Created by 杜进新 on 2018/7/11.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class HomeEntity: BaseModel {
    @objc var user = AccountEntity()
    @objc var property = PropertyEntity()
    @objc var notice = NoticeEntity()
}
class AccountEntity: BaseModel {
    
    @objc var safePwdInit : Int = 0 //是否设置资金密码
    @objc var nickname : String?
    @objc var mobile : String?
    @objc var headImg : String?
    
}
class PropertyEntity: BaseModel {
    
    @objc var balance : Double = 0
    @objc var totalCounts : Double = 0
    @objc var blockedBalance : Double = 0
    
    @objc var address : String?
    @objc var addressImg : String?
}
class NoticeEntity: BaseModel {
   
    @objc var id : Int = 0
    @objc var title : String?
    @objc var url : String?
    @objc var content : String?

}


class PowerRankEntity: BaseModel {
    @objc var user : HomeUserEntity?
    @objc var power : Int = 0
}
class HomeUserEntity: BaseModel {
    @objc var nickname : String?
    @objc var mobile : String?
}
class InviteEntity: BaseModel {
    @objc var inviteCount : String?
    @objc var invitePower : Int = 0
    @objc var inviteCode : String?
    @objc var nickname : String?
}
class DiamondEntity: BaseModel {
    @objc var type : String?
    @objc var diamondId : String?
    @objc var diamondNumber : String?
}
