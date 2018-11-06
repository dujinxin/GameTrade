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
}

extension UIScreen {
    
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
            default:
                return .iPhoneSE
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
