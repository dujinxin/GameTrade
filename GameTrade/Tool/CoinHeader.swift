//
//  CoinHeader.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/31.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

let configuration_valueType = "RMB"

//MARK: 测试
let configuration_coinName = "QQP"
let configuration_coinPrice : Double = 1.0
let configuration_service : Double = 0.02
let configuration_realPrice : Double = configuration_coinPrice - configuration_service
let configuration_merchantName = "王涛-测试商户"
let configuration_merchantID = "9e8bd0113c444529845813138ff74ab0" //测试
//let configuration_merchantID = "30ff6581882c43e3ba223a8df7812a13" //小丁测试
let kIM_AppID = "6456046490195324928"
//let kBaseUrl = "http://192.168.1.122:8080"
let kBaseUrl = "http://app.okshenglian.com"
//let kHtmlUrl = kBaseUrl + "/smart/wallet#/"
//let kHtmlUrl = "http://192.168.0.171:8080" + "/#/"

////MARK: 线上
//let configuration_coinName = "PTB"
//let configuration_coinPrice : Double = 1.0
//let configuration_service : Double = 0.02
//let configuration_realPrice : Double = configuration_coinPrice - configuration_service
//let configuration_merchantName = "王涛-测试商户"
////let configuration_merchantID = "0fe7136968fe44a7929391b695d4de0b" //线上
//
////let configuration_merchantID = "bd343bf51ae3449ea33a3c5c78c0b752" //测试
//
//let kIM_AppID = "6473367894330699776"



////MARK: 线上
//let configuration_coinName = "CSB"
//let configuration_coinPrice : Double = 1.0
//let configuration_service : Double = 0.02
//let configuration_realPrice : Double = configuration_coinPrice - configuration_service
//let configuration_merchantName = "王涛-测试商户"
//let configuration_merchantID = "8413102ec09749b9b743f2e58e2082a2" //线上
//
//let kIM_AppID = "6473367894330699776"


//let kBaseUrl = "https://apps.coinepay.io"
let kHelpUrl = "http://apps.coinepay.io/static/help.html?name=" + configuration_coinName


//1黑色系
let JXOrangeColor = UIColor.rgbColor(rgbValue: 0xff9300)
let JXRedColor = UIColor.rgbColor(rgbValue: 0xEF4262)
let JXGreenColor = UIColor.rgbColor(rgbValue: 0x30DA51)

//let JXMainText50Color = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.5)

let JXPlaceHolerColor = UIColor.rgbColor(rgbValue: 0x686883)

let JX22222cShadowColor = UIColor.rgbColor(rgbValue: 0x22222c, alpha: 0.25)
let JX10101aShadowColor = UIColor.rgbColor(rgbValue: 0x10101a, alpha: 0.15)

//2蓝色系
let JXBlueColor = UIColor.rgbColor(rgbValue: 0x0089f9)
let JXBlue60Color = UIColor.rgbColor(rgbValue: 0x0089f9, alpha: 0.6)

//3橙色系
let JXOrange60Color = UIColor.rgbColor(rgbValue: 0xff9300, alpha: 0.6)

//0 默认黑色系,1黑色系，2蓝色系，3橙色系
#if app_black
let app_style = 1

let JXMainColor = JXOrangeColor
let JXMainTextColor = JXFfffffColor
let JXMainText50Color = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.5)

let JXViewBgColor = UIColor.rgbColor(rgbValue: 0x393948)
let JXTextViewBgColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
let JXTextViewBg1Color = JXViewBgColor
let JXTextViewBg2Color = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
let JXSeparatorColor = UIColor.rgbColor(rgbValue: 0x464855)

let JXLargeTitleColor = JXMainTextColor
let JXLittleTitleColor = JXMainText50Color
let JXOrderDetailBgColor = UIColor.rgbColor(rgbValue: 0x131321)

#elseif app_blue
let app_style = 2

let JXMainColor = JXBlueColor
let JXMainTextColor = UIColor.rgbColor(rgbValue: 0x383838)
let JXMainText50Color = UIColor.rgbColor(rgbValue: 0x383838, alpha: 0.5)

let JXViewBgColor = JXFfffffColor
let JXTextViewBgColor = UIColor.rgbColor(rgbValue: 0xe8e8e8)
let JXTextViewBg1Color = JXTextViewBgColor
let JXTextViewBg2Color = UIColor.rgbColor(rgbValue: 0xb7b7b7, alpha: 0.44)

let JXLargeTitleColor = JXBlueColor
let JXLittleTitleColor = JXBlue60Color
let JXOrderDetailBgColor = JXFfffffColor

let JXSeparatorColor = UIColor.rgbColor(rgbValue: 0xd3dfef)

#elseif app_orange
let app_style = 3

let JXMainColor = JXOrangeColor
let JXMainTextColor = JXFfffffColor
let JXMainText50Color = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.5)

let JXViewBgColor = UIColor.rgbColor(rgbValue: 0x393948)
let JXTextViewBgColor = UIColor.rgbColor(rgbValue: 0xe8e8e8)
let JXTextViewBg1Color = JXTextViewBgColor
let JXTextViewBg2Color = UIColor.rgbColor(rgbValue: 0xb7b7b7, alpha: 0.44)

let JXLargeTitleColor = JXOrangeColor
let JXLittleTitleColor = JXOrange60Color
let JXOrderDetailBgColor = JXFfffffColor

let JXSeparatorColor = UIColor.rgbColor(rgbValue: 0xd3dfef)

#else
let app_style = 0

let JXMainColor = JXOrangeColor
let JXMainTextColor = JXFfffffColor
let JXMainText50Color = UIColor.rgbColor(rgbValue: 0xffffff, alpha: 0.5)

let JXViewBgColor = UIColor.rgbColor(rgbValue: 0x393948)
let JXTextViewBgColor = UIColor.rgbColor(rgbValue: 0x2f2f3c)
let JXTextViewBg1Color = JXViewBgColor
let JXTextViewBg2Color = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
let JXSeparatorColor = UIColor.rgbColor(rgbValue: 0x464855)

let JXLargeTitleColor = JXMainTextColor
let JXLittleTitleColor = JXMainText50Color
let JXOrderDetailBgColor = UIColor.rgbColor(rgbValue: 0x131321)

#endif


