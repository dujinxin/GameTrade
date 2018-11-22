//
//  ConstantHeader.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/3.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation
import UIKit

//MARK:设备
let deviceModel = UIScreen.main.modelSize

//MARK:尺寸类
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kScreenBounds = UIScreen.main.bounds

let kStatusBarHeight = (UIScreen.main.isIphoneX == true) ? CGFloat(44) : CGFloat(20)
let kNavBarHeight = CGFloat(44)
let kNavStatusHeight = kStatusBarHeight + kNavBarHeight
let kBottomMaginHeight : CGFloat = (UIScreen.main.isIphoneX == true) ? 34 : 0
let kTabBarHeight : CGFloat = kBottomMaginHeight + 49

let kHWPercent = (kScreenHeight / kScreenWidth)//高宽比例
let kPercent = kScreenWidth / 375.0

//MARK:颜色

let JX333333Color = UIColor.rgbColor(rgbValue: 0x333333)
let JX666666Color = UIColor.rgbColor(rgbValue: 0x666666)
let JX999999Color = UIColor.rgbColor(rgbValue: 0x999999)
let JXEeeeeeColor = UIColor.rgbColor(rgbValue: 0xeeeeee)
let JXFfffffColor = UIColor.rgbColor(rgbValue: 0xffffff)
let JXF1f1f1Color = UIColor.rgbColor(rgbValue: 0xf1f1f1)

let JXMainColor = UIColor.rgbColor(rgbValue: 0x0469c8)
let JXGrayColor = UIColor.rgbColor(from: 177, 178, 177)

let JXOrangeColor = UIColor.rgbColor(rgbValue: 0xff9300)
let JXRedColor = UIColor.rgbColor(rgbValue: 0xEF4262)
let JXGreenColor = UIColor.rgbColor(rgbValue: 0x30DA51)
let JXPlaceHolerColor = UIColor.rgbColor(rgbValue: 0x686883)
let JXTextColor = JXFfffffColor
let JXText50Color = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.5)
let JXSeparatorColor = UIColor.rgbColor(rgbValue: 0x464855)

let JXBackColor = UIColor.rgbColor(rgbValue: 0x393948)

let JX22222cShadowColor = UIColor.rgbColor(rgbValue: 0x22222c, alpha: 0.25)
let JX10101aShadowColor = UIColor.rgbColor(rgbValue: 0x10101a, alpha: 0.15)









		
