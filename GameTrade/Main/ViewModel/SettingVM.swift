//
//  SettingVM.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/19.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class SettingVM: BaseViewModel {

    lazy var versionEntity: VersionEntity = {
        let entity = VersionEntity()
        return entity
    }()
    /// 版本信息
    func version(_ os: Int = 2, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.version.rawValue, param: ["os": os], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.versionEntity.setValuesForKeys(dict)
            
            completion(data, msg, true)
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
