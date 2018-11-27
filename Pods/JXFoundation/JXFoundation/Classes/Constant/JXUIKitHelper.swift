//
//  JXUIKitHelper.swift
//  JXFoundation
//
//  Created by 杜进新 on 2018/11/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class JXUIKitHelper {

    static let shared = JXUIKitHelper()
    
    private init() {}
    
    public func showNotice(_ notice:String) {
        if notice.isEmpty{
            return
        }
        let noticeView = JXNoticeView.init(text: notice)
        noticeView.show()
    }
    public func showAlert(title: String? = "", message: String? = "", cancelBlock: (()->())?, confirmBlock: (()->())?) -> UIAlertController{
        let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            if let block = cancelBlock {
                block()
            }
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            if let block = confirmBlock {
                block()
            }
        }))
        return alert
    }
}
