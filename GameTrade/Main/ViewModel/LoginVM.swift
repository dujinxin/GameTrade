//
//  LoginVM.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/23.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
import AFNetworking

class LoginVM: JXRequest {

    var dataArray = [[String:AnyObject]]()
    
    var indentifyInfoEntity : IndentifyInfoEntity?
    var profileInfoEntity : ProfileInfoEntity?
    
    
    //获取图片验证码 & 改为直接拼接URL展示
    func getImageCode(type:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(tag: 0, method: .get,url: ApiString.getImageCode.rawValue + "?deviceId=\(type)", param: ["method":type], success: { (data, message) in
            
            guard let _ = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //注册
    func register(mobile: String, password: String, mobileCode: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.register.rawValue, param: ["method": "register", "mobile": mobile, "password": password ,"mobileValidateCode": mobileCode], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //重设密码
    func resetPsd(mobile: String, password: String, mobileCode: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.resetPsd.rawValue, param: ["mobile": mobile, "password": password ,"mobileValidateCode": mobileCode], success: { (data, message) in

            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    
    //实名认证
    func identifyAuth(name:String,idNumber:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.identityAuth.rawValue, param: ["name":name,"idNumber":idNumber], success: { (data, message) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let authStatus = dict["authStatus"] as? Int
                else{
                    completion(nil,message,false)
                    return
            }
            if authStatus == 2 {
                UserManager.manager.userDict["authStatus"] = 2
                let _ = UserManager.manager.saveAccound(dict: UserManager.manager.userDict)
                completion(authStatus,dict["message"] as! String,true)
            } else {
                completion(authStatus,dict["message"] as! String,false)
            }
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //发送验证码
    func sendMobileCode(mobile: String, method: String = "register",validateCode: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        var url = ApiString.sendMobileCodeRegister.rawValue
        if method == "register" {
            url = ApiString.sendMobileCodeRegister.rawValue + "?deviceId=\(UIDevice.current.uuid)"
        } else if method == "resetPwd" {
            url = ApiString.sendMobileCodeForgotPwd.rawValue + "?deviceId=\(UIDevice.current.uuid)"
        } else {
            url = ApiString.sendMobileCodeLogin.rawValue + "?deviceId=\(UIDevice.current.uuid)"
        }
        
        JXRequest.request(url: url, param: ["mobile": mobile, "method": method, "validateCode": validateCode], success: { (data, message) in
            completion(data,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //登录
    func login(userName: String, password: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        JXRequest.request(url: ApiString.login.rawValue, param: ["username": userName, "password": password], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            print(dict)
            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //退出
    func logout(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) {
        JXRequest.request(url: ApiString.logout.rawValue, param: Dictionary(), success: { (data, message) in
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //实名信息
    func identityInfo(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.myIdentity.rawValue, param: Dictionary(), success: { (data, message) in
            
            guard let dict = data as? Dictionary<String, Any>
                else{
                    completion(data,message,false)
                    return
            }
            self.indentifyInfoEntity = IndentifyInfoEntity()
            self.indentifyInfoEntity?.setValuesForKeys(dict)
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //个人信息
    func personInfo(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.profileInfo.rawValue, param: Dictionary(), success: { (data, message) in
            
            guard let dict = data as? Dictionary<String, Any>
                else{
                    completion(data,message,false)
                    return
            }
            self.profileInfoEntity = ProfileInfoEntity()
            self.profileInfoEntity?.setValuesForKeys(dict)
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //修改昵称
    func modify(nickName:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.modifyNickName.rawValue, param: ["nickname":nickName], success: { (data, message) in
            
            //UserManager.manager.userDict["nickname"] = nickName
            //let _ = UserManager.manager.saveAccound(dict: UserManager.manager.userDict)
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
        
    }

    
    func modifyPassword(old:String,new:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) {
        JXRequest.request(url: ApiString.modifiyPwd.rawValue, param: ["oldPassword":old,"newPassword":new], success: { (data, message) in
            
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
        
    }
    
}

class IdentifyVM: JXRequest {
    
    var imageArray : Array<String> = ["facePhoto"]
    //var imageArray : Array<String> = ["facePhoto","idCardFront","idCardBack"]
    
    //识别
    func identifyInfo(param:Dictionary<String,Any> ,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        IdentifyVM.request(url: ApiString.liveAuth.rawValue, param: param, success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>,
                let authStatus = dict["authStatus"] as? Int,
                let msg = dict["message"] as? String
                else{
                    completion(data,message,false)
                    return
            }
            if authStatus == 3 {
                var d = UserManager.manager.userDict
                d["authStatus"] = 3
                let _ = UserManager.manager.saveAccound(dict: dict)
            }
            completion(data,msg,true)
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
                if obj == "facePhoto"{
                    
                    let pathUrl = URL.init(fileURLWithPath: path)
                    guard let data = try? Data(contentsOf: pathUrl) else{
                        return
                    }
                    let stream = InputStream.init(data: data)
                    formData.appendPart(with: stream, name: obj, fileName: "\(obj)\(timeStr)", length: Int64(data.count), mimeType: "image/jpeg")
                    print(data)
                }else{
                    let pathUrl = URL.init(fileURLWithPath: path + ".jpg")
                    guard let data = try? Data(contentsOf: pathUrl) else{
                        return
                    }
                    let stream = InputStream.init(data: data)
                    formData.appendPart(with: stream, name: obj, fileName: "\(obj)\(timeStr).jpg", length: Int64(data.count), mimeType: "image/jpeg")
                    print(data)
                }
                
            }
            
        }
    }
}

class ModifyImageVM: JXRequest {

    //修改头像
    func modifyImage(param:Dictionary<String,Any> ,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        
        ModifyImageVM.request(url: ApiString.modifyAvatar.rawValue, param: param, success: { (data, message) in
//            guard
//                let dict = data as? Dictionary<String, Any>,
//                let authStatus = dict["authStatus"] as? Int,
//                let msg = dict["message"] as? String
//                else{
//                    completion(data,message,false)
//                    return
//            }
//            if authStatus == 3 {
//                var d = UserManager.manager.userDict
//                d["authStatus"] = 3
//                let _ = UserManager.manager.saveAccound(dict: dict)
//            }
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
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] + "/userImage.jpg"
            let pathUrl = URL.init(fileURLWithPath: path)
            guard let data = try? Data(contentsOf: pathUrl) else{
                return
            }
            let stream = InputStream.init(data: data)
            formData.appendPart(with: stream, name: "headImg", fileName: "userImage\(timeStr)", length: Int64(data.count), mimeType: "image/jpeg")
            print(data)
        }
            
    }
}
