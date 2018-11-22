//
//  SettingModel.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/19.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class VersionEntity: BaseModel {

    @objc var id : String?
    @objc var versionNo : Int = 0
    @objc var versionName : String?
    @objc var size : Int = 0
    @objc var url : String?
    @objc var content : String?
    @objc var isMandatory : Int = 0 //是否强制更新
    @objc var mobileOS : String?
}
