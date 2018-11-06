//
//  UIBarButtonItem+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/6.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

public extension  UIBarButtonItem {
    
    /// custom UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: 文字
    ///   - fontSize: default 13
    ///   - imageName:图片名称
    ///   - target:target
    ///   - action:action
    public convenience init(title:String = "",fontSize:CGFloat = 13, imageName:String = "",target:Any,action:Selector) {
        
        let btn = UIButton()
        btn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.darkText, for: .normal)
        if imageName.isEmpty == false {
            btn.setImage(UIImage.init(named: imageName), for: .normal)
        }
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        self.init(customView: btn)
    }

}
