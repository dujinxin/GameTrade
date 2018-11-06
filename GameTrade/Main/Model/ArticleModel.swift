//
//  ArticleModel.swift
//  Star
//
//  Created by 杜进新 on 2018/6/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class ArticleListEntity: BaseModel {
    var total : Int = 0
    @objc var list : Array<ArticleEntity> = Array()
}
class ArticleDetailsEntity: BaseModel {
    @objc var like : Bool = false
    @objc var article : ArticleEntity = ArticleEntity()
}
class ArticleEntity: BaseModel {
    @objc var artHashIndex : Int = 0
    @objc var artStatus : Int = 0
    @objc var coverImg : String?
    @objc var cdnUrl : String?
    @objc var id : String?
    @objc var title : String?
    @objc var releaseDate : String?
    
    @objc var views : Int = 0
    @objc var likes : Int = 0
}

class ArticleChainEntity: BaseModel {
    @objc var ipfsUrl : String?
    @objc var ipfsNodeUrl : String?
    @objc var blockHash : String?
    @objc var blockHashPre : String?
    @objc var blockHeight : String?
    @objc var tradeHash : String?
}

