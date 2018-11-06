//
//  ViewManager.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation
import JXFoundation

class ViewManager : NSObject{
    
    static let manager = ViewManager()
    
    override init() {
        super.init()
    }
    
    class func showNotice(_ notice:String) {
        if notice.isEmpty{
            return
        }
        let noticeView = JXNoticeView.init(text: notice)
        noticeView.show()
    }
    
    public func showNotice1(notice:String) {
        let noticeView = JXNoticeView.init(text: notice)
        noticeView.show()
    }
    
}
