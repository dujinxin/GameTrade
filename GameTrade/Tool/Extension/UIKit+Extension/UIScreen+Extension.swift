//
//  UIScreen+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/3.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

enum Model:String {
    case iPhoneSE
    case iPhone8
    case iPhone8p
    case iPhoneX
    case iPhoneXR
    case iPhoneXM
}

extension UIScreen {
    
    var isIphoneX : Bool {
        get{
            if self.modelSize == .iPhoneX || self.modelSize == .iPhoneXR || self.modelSize == .iPhoneXM {
                return true
            } else {
                return false
            }
        }
    }
    
    var modelSize: Model {
        get{
            
            guard let mode = self.currentMode
                else {
                    return .iPhoneSE
            }
            switch mode.size {
            case CGSize(width: 640.0, height: 1136.0):
                return .iPhoneSE
            case CGSize(width: 750.0, height: 1334.0):
                return .iPhone8
            case CGSize(width: 1242.0, height: 2208.0):
                return .iPhone8p
            case CGSize(width: 1125.0, height: 2436.0):
                return .iPhoneX
            case CGSize(width: 828.0, height: 1792.0):
                return .iPhoneXR
            case CGSize(width: 1242.0, height: 2688.0):
                return .iPhoneXM
            default:
                return .iPhoneX
            }
        }
    }
    
    var screenSize : CGSize {
        get{
            return bounds.size
        }
    }
    var screenWidth : CGFloat {
        get{
            return bounds.width
        }
    }
    var screenHeight : CGFloat {
        get{
            return bounds.height
        }
    }
    
//    var model : Model {
//        get{
//            switch self.modelName {
//            case "iPhone X":
//                return .iPhoneX
//            default:
//                return .iPhone8p
//            }
//        }
//    }
    
}
