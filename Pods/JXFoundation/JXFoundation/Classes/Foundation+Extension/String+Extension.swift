//
//  String+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation
import UIKit

public enum  RegularExpression : String{
    case none                = ""          //
    
    case phone               = "^1\\d{10}$"   //手机号，只做1开头11位的基本校验
    case identityCard        = "^(\\d{14}|\\d{17})(\\d|[xX])$"//身份证号
    case number              = "[0-9]*"       //数字
    case letter              = "[a-zA-Z]*"    //字母
    case chinese             = "[\\u4e00-\\u9fa5]+"  //汉字
    case numberOrNumber      = "[a-zA-Z0-9]*" //数字或字母
    case code4               = "^[0-9]{4}+$"  //四位验证码
    case code6               = "^[0-9]{6}+$"  //六位验证码
//    case number = ""
    
}

public extension String {
    
    /// 字符串校验
    ///
    /// - Parameters:
    ///   - string: 需要校验的字符串
    ///   - type: 类型
    /// - Returns: 结果
    public func validate(type:RegularExpression) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return predicate.evaluate(with: self)
    }
    public static func validate(_ string:String, type:RegularExpression) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", type.rawValue)
        return predicate.evaluate(with: string)
    }
    
    public static func validate(_ string:String?,type:RegularExpression,emptyMsg:String?,formatMsg:String) -> Bool{
        guard let str = string, str.isEmpty == false else {
            let notice = JXNoticeView.init(text: emptyMsg ?? formatMsg)
            notice.show()
            return false
        }
        if type == .none {
            return true
        }
        if !self.validate(str, type: type) {
            let notice = JXNoticeView.init(text: formatMsg)
            notice.show()
            return false
        } else {
            return true
        }
    }
}
//MARK:计算
extension String {
    
    public func calculate(width: CGFloat,fontSize:CGFloat,lineSpace:CGFloat = -1) -> CGSize {
        
        if self.isEmpty {
            return CGSize()
        }
        
        let ocText = self as NSString
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
        
        return CGSize(width: width, height: height)
    }
}
//MARK:加密
public extension String {
//    func md5(string:String) -> String {
//        return MD5.encode(string)
//    }
//    func base64encode(string:String) -> String? {
//        return Base64.stringDecode(string)
//    }
//    func base64decode(string:String) -> String? {
//        return Base64.stringDecode(string)
//    }
}
