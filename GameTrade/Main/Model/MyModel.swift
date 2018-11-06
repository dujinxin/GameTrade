//
//  MyModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/8.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class IndentifyInfoEntity: BaseModel {
    @objc var idNumber : String?
    @objc var name : String?
    @objc var mobile : String?
    @objc var faceAuth : Int = 0
}

class ProfileInfoEntity: BaseModel {
    @objc var nickname : String?
    @objc var safePwdInit : Int = 0 //安全密码是否初始化,false未初始化，true已初始化
    @objc var headImg : String?
    @objc var mobile : String?
}

