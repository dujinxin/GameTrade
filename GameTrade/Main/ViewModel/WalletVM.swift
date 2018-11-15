//
//  WalletVM.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletVM: BaseViewModel {
    
    //交易列表
    lazy var tradeListEntity: TradeListEntity = {
        let entity = TradeListEntity()
        return entity
    }()
    //交易详情
    lazy var tradeDetailEntity: TradeDetailEntity = {
        let entity = TradeDetailEntity()
        return entity
    }()
    
    //交易列表
    func tradeList(pageSize: Int = 10, pageNo: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.tradeList.rawValue, param: ["pageSize": pageSize, "pageNo": pageNo], success: { (data, msg) in
            
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
                    self.tradeListEntity.listArray.removeAll()
                }
                self.tradeListEntity.total = total
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = TradeEntity()
                    entity.setValuesForKeys(dict)
                    
                    self.tradeListEntity.listArray.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //交易详情
    func tradeDetail(type: Int, bizId: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.tradeDetail.rawValue, param: ["type": type, "bizId": bizId], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.tradeDetailEntity.setValuesForKeys(dict)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
