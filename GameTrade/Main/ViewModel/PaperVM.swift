//
//  PaperVM.swift
//  Star
//
//  Created by 杜进新 on 2018/7/24.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class PaperVM : BaseViewModel{
  
    //论文列表
    lazy var paperListEntity: PaperListEntity = {
        let entity = PaperListEntity()
        return entity
    }()
    //论文详情
    lazy var paperDetailEntity: PaperDetailEntity = {
        let entity = PaperDetailEntity()
        return entity
    }()
    var detailList = Array<CustomDetailEntity>()
    //论文交易
    lazy var paperTradeEntity: PaperTradeEntity = {
        let entity = PaperTradeEntity()
        return entity
    }()
    //邀请
    lazy var inviteEntity: InviteEntity = {
        let entity = InviteEntity()
        return entity
    }()
    
    
    /// 论文列表
    func paperList(append: Bool = false, pageSize: Int = 10, pageNo: Int,completion: @escaping ((_ data: Any?, _ msg: String,_ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.paperList.rawValue, param: ["pageSize":pageSize,"pageNo":pageNo], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let total = dict["total"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.paperListEntity.total = total
            if pageNo == 1 {
                self.paperListEntity.list.removeAll()
            }
            if total > 0 {
                guard
                    var list = dict["list"] as? Array<Dictionary<String, Any>>
                    else{
                        completion(nil, self.message, false)
                        return
                }
                if pageNo == 1 {
                    
                    for _ in 0..<list.count{
                        let j = arc4random_uniform(UInt32(list.count))
                        print(j)
                        let dict = list.remove(at: Int(j)) //list[Int(j)]
                        let entity = PaperEntity()
                        entity.setValuesForKeys(dict)
                        self.paperListEntity.list.append(entity)
                    }
                } else {
                    for i in 0..<list.count{
                        let dict = list[i]
                        let entity = PaperEntity()
                        entity.setValuesForKeys(dict)
                        self.paperListEntity.list.append(entity)
                    }
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 论文详情
    func paperDetails(_ id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.paperDetail.rawValue, param: ["id":id], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let power = dict["power"] as? Int,
                let thesis = dict["thesis"] as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            
            self.paperDetailEntity.power = power
            self.paperDetailEntity.paperEntity.setValuesForKeys(thesis)
            self.customList()
          
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    func customList() {
        if let entity = self.entity(key: "author") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "office") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "thesisAbstract") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "fund") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "keyword") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "doi") {
            self.detailList.append(entity)
        }
        if let entity = self.entity(key: "source") {
            self.detailList.append(entity)
        }
    }
    
    func entity(key: String?) -> CustomDetailEntity? {
        guard let key = key, key.isEmpty == false else {
            return nil
        }
        let entity = CustomDetailEntity()
        switch key {
        case "author":
            entity.title = "【作者】"
            guard let text = self.paperDetailEntity.paperEntity.author else {
                return nil
            }
            let str = text.replacingOccurrences(of: ",", with: "   ")
            entity.content = str
        case "office":
            entity.title = "【机构】"
            guard let text = self.paperDetailEntity.paperEntity.office, text.isEmpty == false else {
                return nil
            }
            let str = text.replacingOccurrences(of: ",", with: "\n")
            entity.content = str
        case "thesisAbstract":
            entity.title = "【摘要】"
            entity.content = self.paperDetailEntity.paperEntity.thesisAbstract
        case "fund":
            entity.title = "【基金】"
            guard let text = self.paperDetailEntity.paperEntity.fund, text.isEmpty == false else {
                return nil
            }
            let str = text.replacingOccurrences(of: ",", with: "\n")
            entity.content = str
        case "keyword":
            entity.title = "【关键词】"
            guard let text = self.paperDetailEntity.paperEntity.keyword else {
                return nil
            }
            let str = text.replacingOccurrences(of: ",", with: "   ")
            entity.content = str
        case "doi":
            entity.title = "【DOI】"
            guard let text = self.paperDetailEntity.paperEntity.doi, text.isEmpty == false else {
                return nil
            }
            entity.content = text
        case "source":
            entity.title = "【来源期刊】"
            entity.content = self.paperDetailEntity.paperEntity.source
        default:
            return nil
        }
        return entity
    }
    /// 论文购买
    func paperTrade(_ id: String, completion: @escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.paperTrade.rawValue, param: ["id":id], success: { (data, msg) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil, self.message, false)
                    return
            }
            self.paperTradeEntity.setValuesForKeys(dict)
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 论文下载
    func paperDownload(_ url: String, named: String = "123", process:@escaping ((_ process: Progress)->()), completion:@escaping ((_ isSuccess: Bool, _ url: URL?)->())) -> Void{

        guard let Url = URL.init(string: url) else { return }
        let title = Url.lastPathComponent
        let filePath1 = NSHomeDirectory() + "/Documents/" + title
        let filePath2 = NSHomeDirectory() + "/Documents/" + title + ".pdf"
        
        if FileManager.default.fileExists(atPath: filePath1) == true {
            let fileUrl = URL.init(fileURLWithPath: filePath1)
            completion(true, fileUrl)
        } else if FileManager.default.fileExists(atPath: filePath2) == true {
            let fileUrl = URL.init(fileURLWithPath: filePath2)
            completion(true, fileUrl)
        } else {
            JXRequest.download(urlStr: url, destination: { (fileUrl, urlResponse) -> (URL) in
                return URL.init(fileURLWithPath: NSHomeDirectory() + "/Documents/" + (urlResponse.suggestedFilename ?? named))
            }, progress: process) { (urlResponse, fileUrl, error) in
                //print(fileUrl)
                //print(urlResponse.textEncodingName,urlResponse.suggestedFilename)
                if let _ = error {
                    completion(false, fileUrl)
                } else {
                    completion(true, fileUrl)
                }
            }
        }
    }
}
