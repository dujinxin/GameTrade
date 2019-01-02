//
//  AlamofireVM.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/12/25.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireVM: BaseViewModel {

    //登录
    func login(userName: String, password: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.login.rawValue, param: ["username": userName, "password": MD5.encode(password)], success: { (data, message) in
            guard
                var dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            print(dict)
            if let baseInfo = dict["baseInfo"] as? Dictionary<String, Any> {
                baseInfo.forEach({ (key,value) in
                    dict[key] = value
                })
                //let _ = UserManager.manager.saveAccound(dict: dict)
            }
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}
