//
//  HomeVM.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class HomeVM: BaseViewModel {
    
    //首页
    lazy var homeEntity: HomeEntity = {
        let entity = HomeEntity()
        return entity
    }()
    //资产记录
    lazy var noticeEntity: NoticeEntity = {
        let entity = NoticeEntity()
        return entity
    }()
 
    func home(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.homeInfo.rawValue, param: [:], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            if let baseInfo = result["baseInfo"] as? Dictionary<String, Any> {
                self.homeEntity.user.setValuesForKeys(baseInfo)
                UserManager.manager.userEntity.user.setValuesForKeys(baseInfo)
            }
            if let walletInfo = result["walletInfo"] as? Dictionary<String, Any> {
                self.homeEntity.property.setValuesForKeys(walletInfo)
                UserManager.manager.userEntity.property.setValuesForKeys(walletInfo)
            }
            if let notice = result["notice"] as? Dictionary<String, Any> {
                self.homeEntity.notice.setValuesForKeys(notice)
            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func homeNotice(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.homeNotice.rawValue, param: [:], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.noticeEntity.setValuesForKeys(result)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
