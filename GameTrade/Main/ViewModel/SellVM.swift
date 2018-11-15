//
//  SellVM.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/3.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SellVM: BaseViewModel {
    
    //卖单列表
    lazy var sellListEntity: SellListEntity = {
        let entity = SellListEntity()
        return entity
    }()
    var id : String = ""
    
    //个人账户余额，收款账户
    lazy var sellInfoEntity: SellInfoEntity = {
        let entity = SellInfoEntity()
        return entity
    }()
    
    //币商详情
    lazy var merchantEntity: MerchantEntity = {
        let entity = MerchantEntity()
        return entity
    }()
    
    //卖单列表
    func sellList(completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.sellList.rawValue, param: [:], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let total = dict["total"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
            if total > 0 {
                guard
                    let list = dict["data"] as? Array<Dictionary<String, Any>>
                    else{
                        completion(nil, self.message, false)
                        return
                }
//                if pageNo == 1 {
                    self.sellListEntity.listArray.removeAll()
//                }
                self.sellListEntity.total = total
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = SellEntity()
                    entity.setValuesForKeys(dict)
                    
                    self.sellListEntity.listArray.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func sellInfo(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.sellInfo.rawValue, param: Dictionary(), success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.sellInfoEntity.setValuesForKeys(dict)
            
            if let list = dict["accounts"] as? Array<Dictionary<String, Any>> {
                for dict in list{
                    let entity = PayEntity()
                    entity.setValuesForKeys(dict)
                    self.sellInfoEntity.list.append(entity)
                }
            }
            
//            if let balance = dict["balance"] as? Double {
//                self.sellInfoEntity.balance = balance
//            }
//            if let saleRate = dict["saleRate"] as? String, let rate = Double(saleRate){
//                self.sellInfoEntity.saleRate = rate
//            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //挂卖单 商家
    func sellCreate(payType: Int, amount: Int, safePassword: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.sellCreate.rawValue, param: ["payType": payType, "amount": amount, "safePassword": safePassword], success: { (data, msg) in
            
            completion(data, msg, true)
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //卖单删除
    func sellDelete(id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.sellDelete.rawValue, param: ["id": id], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //发币  用户
    func transfer(address: String, amount: Int, safePassword: String, remarks: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.transferCoin.rawValue, param: ["address": address, "amount": amount,"safePassword": safePassword, "remarks": remarks], success: { (data, msg) in
            
            completion(data, msg, true)
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    //卖单列表
    func merchantDetail(id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.merchantDetail.rawValue, param: ["id": id], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.merchantEntity.setValuesForKeys(dict)
            if
                let list = dict["sales"] as? Array<Dictionary<String, Any>> {
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = MerchantOrderEntity()
                    entity.setValuesForKeys(dict)
                    
                    self.merchantEntity.listArray.append(entity)
                }
            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
