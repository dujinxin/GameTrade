//
//  OrderVM.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderVM: BaseViewModel {

    //订单记录
    lazy var orderListEntity: OrderListEntity = {
        let entity = OrderListEntity()
        return entity
    }()
    var id : String = ""
    
    //订单详情
    lazy var orderDetailEntity: OrderDetailEntity = {
        let entity = OrderDetailEntity()
        return entity
    }()
    var detailList = Array<CustomDetailEntity>()
    
    //订单记录列表
    func orderList(pageSize: Int = 10, pageNo: Int, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.orderList.rawValue, param: ["pageSize": pageSize, "pageNo": pageNo], success: { (data, msg) in
            
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
                    self.orderListEntity.listArray.removeAll()
                }
                self.orderListEntity.total = total
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = OrderEntity()
                    entity.setValuesForKeys(dict)
                    
                    self.orderListEntity.listArray.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //订单详情
    func orderDetail(id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.orderDetail.rawValue, param: ["id": id], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.orderDetailEntity.setValuesForKeys(dict)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    //买单取消
    func buyCancel(id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.buyCancel.rawValue, param: ["id": id], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    //买单付款确认
    func buyConfirm(id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.buyConfirm.rawValue, param: ["id": id], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //卖单付款确认
    func sellConfirm(id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.sellConfirm.rawValue, param: ["id": id], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    
    
}
