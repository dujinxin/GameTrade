//
//  BaseModel.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

class BaseModel: NSObject {

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("class:\(type(of: self)) undefinedKey:\(key)")
        //print("class:\(type(of: self)) undefinedKey:\(key) Value:\(String(describing: value))")
    }
}
