//
//  TaskVM.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation
import AFNetworking

class PayVM: BaseViewModel {
    
    var payListEntity : PayListEntity?
    
    var bankListEntity = BankListEntity()
    var bankFormatDictionary = Dictionary<String, Array<BankEntity>>()
    var bankIndexList = Array<String>()
    
    func payList(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.payList.rawValue, param: Dictionary(), success: { (data, msg) in

            guard
                let arr = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.payListEntity = PayListEntity()
            
            
//            for i in 1..<4 {
//                let entity = PayEntity()
//                entity.type = i
//                if entity.type == 1 {
//                    self.payListEntity.list["ali"] = entity
//                } else if entity.type == 2 {
//                    self.payListEntity.list["weChat"] = entity
//                } else {
//                    self.payListEntity.list["card"] = entity
//                }
//            }
            
            for dict in arr{
                let entity = PayEntity()
                
                entity.setValuesForKeys(dict)
                entity.isEmpty = 0
                
                if entity.type == 1 {
                    self.payListEntity?.list["ali"] = entity
                } else if entity.type == 2 {
                    self.payListEntity?.list["weChat"] = entity
                } else {
                    self.payListEntity?.list["card"] = entity
                }
                    
                //self.payListEntity.list.append(entity)
            }
 
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }

    func bankList(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.bankList.rawValue, param: Dictionary(), success: { (data, msg) in
            
            guard
                let arr = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.makeBankToGroup(arr: arr)
//            self.bankListEntity.list.removeAll()
//            for dict in arr{
//
//                let entity = BankEntity()
//                entity.setValuesForKeys(dict)
//                self.bankListEntity.list.append(entity)
//            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
  
    func makeBankToGroup(arr : Array<Dictionary<String, Any>>) {
        // 遍历citys数组中的所有城市
        for dict in arr {
            
            
            // 将中文转换为拼音
//            let cityMutableString = NSMutableString(string: city)
//            CFStringTransform(cityMutableString, nil, kCFStringTransformToLatin, false)
//            CFStringTransform(cityMutableString, nil, kCFStringTransformStripDiacritics, false)
            // 拿到首字母作为key
//            let firstLetter = cityMutableString.substringToIndex(1).uppercaseString
            
            // 检查是否有firstLetter对应的分组存在, 有的话直接把city添加到对应的分组中
            // 没有的话, 新建一个以firstLetter为key的分组
            guard let str = dict["pinyin"] as? String else { return }
            let key = str.prefix(1).uppercased()
            let entity = BankEntity()
            entity.setValuesForKeys(dict)
            
            if var subArr = bankFormatDictionary[key] {
                subArr.append(entity)
                bankFormatDictionary[key] = subArr
            } else {
                bankFormatDictionary[key] = [entity]
            }
        }
    
        //拿到所有的key将它排序, 作为每个组的标题
        bankIndexList = bankFormatDictionary.keys.sorted()
    }
    
    
    //添加修改支付方式
    
    func editPay(id: String = "", type: Int, bank: String, account: String, name: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.editPayStyle.rawValue, param: ["id": id, "type": type, "bank": bank, "account": account, "name": name], success: { (data, message) in
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //删除支付方式
    
    func deletePay(id: String, payType: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.deletePayStyle.rawValue, param: ["id": id, "payType": payType], success: { (data, message) in
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }

}
class WeChatOrAliVM: JXRequest {
    
    var imageArray : Array<String> = ["userImage"]

    //添加或修改支付方式
    func editPay(id: String = "", type: Int, account: String, name: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        WeChatOrAliVM.request(url: ApiString.editPayStyle.rawValue, param: ["id": id, "type": type, "account": account, "name": name], success: { (data, message) in
            completion(nil,message,true)
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
                print("get image data success: \(path)")
                let stream = InputStream.init(data: data)
                formData.appendPart(with: stream, name: "qrcodeImg", fileName: "\(obj)\(timeStr).jpg", length: Int64(data.count), mimeType: "image/jpeg")
                
            }
        }
    }
}
