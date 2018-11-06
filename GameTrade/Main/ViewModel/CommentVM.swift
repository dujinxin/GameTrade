//
//  CommentVM.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class CommentVM: BaseViewModel {
    var orderCount : Int = 0
    
    /// 评论列表
    func commentList(append:Bool = false,artId:String,artHashIndex:Int,pageSize:Int = 20,pageNo:Int,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.articleCommentList.rawValue, param: ["artId":artId,"artHashIndex":artHashIndex,"pageSize":pageSize,"pageNo":pageNo], success: { (data, msg) in
            
            guard
                let dict = data as? Dictionary<String, Any>,
                let total = dict["total"] as? Int
                else{
                    completion(nil, self.message, false)
                    return
            }
            if pageNo == 1 {
                self.dataArray.removeAll()
            }
            if total > 0 {
                guard
                    let list = dict["commentList"] as? Array<Dictionary<String, Any>>
                    else{
                        completion(nil, self.message, false)
                        return
                }
                
                for i in 0..<list.count{
                    let dict = list[i]
                    let entity = CommentListEntity()
                    entity.setValuesForKeys(dict)
                    if let d = dict["user"] as? Dictionary<String,Any> {
                        entity.user = UserEntity1()
                        entity.user?.setValuesForKeys(d)
                    }
                    self.dataArray.append(entity)
                }
            }
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 发表评论
    func comment(_ content:String,articleHash:Int, articleId:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.articleComment.rawValue, param: ["comment":content,"artId":articleId,"artHashIndex":articleHash], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    /// 点赞评论
    /// 1取消点赞，2点赞
    func like(_ status:Int,articleHash:Int, articleId:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.articleRead.rawValue, param: ["status":status,"id":articleId,"artIndexHash":articleHash], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    /// 删除评论
    func delete(_ commentId:String,artHashIndex:Int,artId:String,completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) -> Void{
        JXRequest.request(url: ApiString.articleCommentDelete.rawValue, param: ["id":commentId,"artHashIndex":artHashIndex,"artId":artId], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
