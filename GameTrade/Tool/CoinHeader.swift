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

