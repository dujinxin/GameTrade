//
//  CommenModel.swift
//  ZPOperator
//
//  Created by 杜进新 on 2018/1/19.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class CommenModel: BaseModel {

}
//
class MainSubModel: BaseModel {
    var name : String?
    var id : Int = -1
}
//
class OperatorModel: BaseModel {
    var name : String?
    var station : String?
    
    var stationLocation : String? //全程溯源中独有
}
//
class DeliverDirectCodeSizeModel: BaseModel {
    var id : Int = 0
    var desc : String?
}
