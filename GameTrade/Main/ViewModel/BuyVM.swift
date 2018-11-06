//
//  BuyVM.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class BuyVM: BaseViewModel {
    
    //交易记录
    lazy var buyListEntity: BuyListEntity = {
        let entity = BuyListEntity()
        return entity
    }()
    var id : String = ""
    
    //交易详情
    lazy var tradeDetailEntity: BuyListEntity = {
        let entity = BuyListEntity()
        return entity
    }()
    var detailList = Array<CustomDetailEntity>()
    
    //交易记录列表  0全部 1支付宝，2微信，3银行卡
    func buyList(payType: Int, pageSize: Int = 10, pageNo: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.buyList.rawValue, param: ["payType": payType, "pageSize": pageSize, "pageNo": pageNo], success: { (data, msg) in
            
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
                if pageNo == 1 {
                    self.buyListEntity.listArray.removeAll()
                }
                self.buyListEntity.total = total
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = BuyEntity()
                    entity.setValuesForKeys(dict)
                    if let agent = dict["agent"] as? Dictionary<String, Any>{
                        entity.agentEntity.setValuesForKeys(agent)
                    }
                    self.buyListEntity.listArray.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //快捷购买
    func buyQuick(payType: Int, amount: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.buyQuick.rawValue, param: ["payType": payType, "amount": amount], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let id = dict["id"] as? String
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.id = id
            print(id)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //普通购买
    func buyNormal(tradeSaleId: String, amount: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.buyNormal.rawValue, param: ["tradeSaleId": tradeSaleId, "amount": amount], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let id = dict["id"] as? String
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.id = id
            print(id)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
