//
//  MyVM.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import AFNetworking

class MyVM: BaseViewModel {
    
    var validateResult : Int = 0
    
    //发送验证码  1修改登录密码,2修改资金密码
    func sendMobileCode(type: Int = 1, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        let url : String
        if type == 1 {
            url = ApiString.modifyLogPsdSendCode.rawValue + "?deviceId=\(UIDevice.current.uuid)"
        } else {
            url = ApiString.modifyTradePsdSendCode.rawValue + "?deviceId=\(UIDevice.current.uuid)"
        }
        
        JXRequest.request(url: url, param: [:], success: { (data, message) in
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //修改登录密码
    func modifyLogPsd(code: String, password: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.modifyLogPsd.rawValue, param: ["mobileValidateCode": code,"password": password], success: { (data, message) in
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    
    
    //修改资金密码 校验验证码
    func modifyTradeValidatePsd(code: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.modifyTradePsdValidateCode.rawValue, param: ["mobileValidateCode": code], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>,
                let validateResult = dict["validateResult"] as? Int
                else{
                    completion(nil,message,false)
                    return
            }
            print(validateResult)
            self.validateResult = validateResult
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //修改资金密码
    func modifyTradePsd(code: String, password: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.modifyTradePsd.rawValue, param: ["mobileValidateCode": code,"safePassword": password], success: { (data, message) in
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //资金密码初始化
    func tradePsdInit(password: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.tradePsdInit.rawValue, param: ["safePassword": password], success: { (data, message) in
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}

class FeedBackVM: JXRequest {
    
    var imageArray : Array<String> = ["photo1","photo2","photo3"]
   
    //反馈
    func feedBack(param:Dictionary<String,Any> ,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        FeedBackVM.request(url: ApiString.feedBack.rawValue, param: param, success: { (data, message) in
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    override func customConstruct() -> JXBaseRequest.ConstructingBlock? {
        return {(_ formData : AFMultipartFormData) -> () in
            let format = DateFormatter()
            format.dateFormat = "yyyyMMddHHmmss"
            let timeStr = format.string(from: Date.init())
            
            for obj in self.imageArray {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] + "/\(obj)" + ".jpg"
                let pathUrl = URL.init(fileURLWithPath: path)
                guard let data = try? Data(contentsOf: pathUrl) else{
                    return
                }
                let stream = InputStream.init(data: data)
                formData.appendPart(with: stream, name: obj, fileName: "\(obj)\(timeStr).jpg", length: Int64(data.count), mimeType: "image/jpeg")
                
            }
        }
    }
}
