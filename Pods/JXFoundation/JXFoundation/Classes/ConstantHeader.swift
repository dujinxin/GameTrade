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
public let deviceModel = UIScreen.main.modelSize

//MARK:尺寸类
public let kScreenWidth = UIScreen.main.bounds.width
public let kScreenHeight = UIScreen.main.bounds.height
public let kScreenBounds = UIScreen.main.bounds

public let kStatusBarHeight = (deviceModel == .iPhoneX) ? CGFloat(44) : CGFloat(20)
public let kNavBarHeight = CGFloat(44)
public let kNavStatusHeight = kStatusBarHeight + kNavBarHeight
public let kTabBarHeight = CGFloat(49)

public let kHWPercent = (kScreenHeight / kScreenWidth)//高宽比例
public let kPercent = kScreenWidth / 375.0


//MARK:颜色

public let JX333333Color = UIColor.rgbColor(rgbValue: 0x333333)
public let JX666666Color = UIColor.rgbColor(rgbValue: 0x666666)
public let JX999999Color = UIColor.rgbColor(rgbValue: 0x999999)
public let JXEeeeeeColor = UIColor.rgbColor(rgbValue: 0xeeeeee)
public let JXFfffffColor = UIColor.rgbColor(rgbValue: 0xffffff)
public let JXF1f1f1Color = UIColor.rgbColor(rgbValue: 0xf1f1f1)

public let JXDebugColor = UIColor.randomColor


//MARK:字体
//let JXFontNormarl










		
