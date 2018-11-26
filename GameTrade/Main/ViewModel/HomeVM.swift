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
    
    var totalWidth : CGFloat = 0
    var useWidth : CGFloat = 0
    var limitWidth : CGFloat = 0
 
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
                self.calculteWidth()
            }
            if let notice = result["notice"] as? Dictionary<String, Any> {
                self.homeEntity.notice.setValuesForKeys(notice)
            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    func calculteWidth() {
        let text1 = "=\(self.homeEntity.property.totalCounts) RMB"
        self.totalWidth = self.calculate1(text: text1, width: 300, fontSize: 12).width
        
        let text2 = "=\(self.homeEntity.property.balance) RMB"
        self.useWidth = self.calculate1(text: text2, width: 300, fontSize: 9).width
        
        let text3 = "=\(self.homeEntity.property.blockedBalance) RMB"
        self.limitWidth = self.calculate1(text: text3, width: 300, fontSize: 9).width
    }
    func calculate1(text: String, width: CGFloat, fontSize: CGFloat, lineSpace: CGFloat = -1) -> CGSize {
        
        if text.isEmpty {
            return CGSize()
        }
        
        let ocText = text as NSString
        var attributes : Dictionary<NSAttributedString.Key, Any>
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        
        if lineSpace < 0 {
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        }else{
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle:paragraph]
        }
        
        let rect = ocText.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading,.usesDeviceMetrics], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.x < 0 {
            height = abs(rect.origin.x) + rect.height
        }else{
            height = rect.height
        }
        
        return CGSize(width: rect.width + 20, height: height)
    }
    //扫码支付
    var bizId : String = ""
    var webName : String = ""
    var amount : Double = 0
    
    func scanPayGetInfo(sign: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.scanPayGetInfo.rawValue, param: ["sign": sign], success: { (data, msg) in
            guard
                let dict = data as? Dictionary<String, Any>,
                let webName = dict["webName"] as? String,
                let amount = dict["amount"] as? Double
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.webName = webName
            self.amount = amount
            completion(data, msg, true)
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func scanPay(sign: String, safePassword: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.scanPay.rawValue, param: ["sign": sign, "safePassword": safePassword], success: { (data, msg) in
            guard
                let dict = data as? Dictionary<String, Any>,
                let id = dict["bizId"] as? String
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.bizId = id
            completion(data, msg, true)
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
