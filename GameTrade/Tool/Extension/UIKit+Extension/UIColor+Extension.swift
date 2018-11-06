//
//  UIColor+Extension.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/9.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

extension UIColor{
    
    /// 通过16进制数值设置色值
    ///
    /// - Parameters:
    ///   - rgbValue: RGB 色值
    ///   - alpha: 透明度
    /// - Returns: UIColor
    class func rgbColor(rgbValue :Int, alpha:CGFloat = 1.0) -> UIColor {
        
        let color = UIColor(red: (CGFloat((rgbValue & 0xFF0000) >> 16))/255.0,
                            green: (CGFloat((rgbValue & 0xFF00) >> 8))/255.0,
                            blue: (CGFloat(rgbValue & 0xFF))/255.0,
                            alpha: alpha)
        
        return color
    }
    
    /// 通过RGB数值设置色值
    ///
    /// - Parameters:
    ///   - red: 0~255的 CGFloat数值
    ///   - green: 0~255的 CGFloat数值
    ///   - blue: 0~255的 CGFloat数值
    ///   - alpha: 0~1 CGFloat数值
    /// - Returns: UIColor
    class func rgbColor(from red:CGFloat, _ green:CGFloat, _ blue:CGFloat ,_ alpha:CGFloat = 1.0) -> UIColor {
        let color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        return color
    }
    
    /// 调试颜色
    var debugColor : UIColor?{
        set{
            
        }
        get{
            if isDebug == true {
                return UIColor.randomColor
            }else{
                return UIColor.clear
            }
        }
    }
    /// 随机色值,各种颜色，计算型类属性
    ///
    /// - Returns: UIColor
    class var randomColor : UIColor {
        let color = UIColor(red:CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
        return color
    }
    
    class var jx333333Color : UIColor {
        return UIColor.rgbColor(rgbValue: 0x333333)
    }
    class var jx666666Color : UIColor {
        return UIColor.rgbColor(rgbValue: 0x666666)
    }
    class var jx999999Color : UIColor {
        return UIColor.rgbColor(rgbValue: 0x999999)
    }
    class var jxeeeeeeColor : UIColor {
        return UIColor.rgbColor(rgbValue: 0xeeeeee)
    }
    class var jxffffffColor : UIColor {
        return UIColor.rgbColor(rgbValue: 0xffffff)
    }
    class var jxf1f1f1Color : UIColor {
        return UIColor.rgbColor(rgbValue: 0xf1f1f1)
    }
    //
    class var mainColor: UIColor {
        return UIColor.rgbColor(rgbValue: 0x0469c8)
    }
    class var operatorOrangeColor: UIColor {
        return UIColor.rgbColor(from: 219, 80, 8)
    }
}


