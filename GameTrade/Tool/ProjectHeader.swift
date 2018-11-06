//
//  ProjectHeader.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/7.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation

let kVersion = "v1.0.0"


// FaceParameter
// 如果在后台选择自动配置授权信息，下面的三个LICENSE相关的参数已经配置好了
// 只需配置FACE_API_KEY和FACE_SECRET_KEY两个参数即可

// 人脸license文件名
let FACE_LICENSE_NAME  = "idl-license"

// 人脸license后缀
let FACE_LICENSE_SUFFIX  = "face-ios"

// （您申请的应用名称(appname)+「-face-ios」后缀，如申请的应用名称(appname)为test123，则此处填写test123-face-ios）
// 在后台 -> 产品服务 -> 人脸识别 -> 客户端SDK管理查看，如果没有的话就新建一个
let FACE_LICENSE_ID    =    "mingmaistar-face-ios"

// OCR license文件名
let OCR_LICENSE_NAME = "OCR LICENSE的名字"

// OCR license后缀
let OCR_LICENSE_SUFFIX = "OCR LICENSE的后缀"

// 以下两个在后台 -> 产品服务 -> 人脸识别 -> 应用列表下面查看，如果没有的话就新建一个
let FACE_API_KEY = "W3P93CGlo1NpFAfLDmLT6mZI"
// 您的Secret Key
let FACE_SECRET_KEY = "XXbGTW9EzH0uHafnMpYzV2q7Sma343DS"

//高德
//let GDAppKey = "f7a2643ca6c7d197ad7518098000df5f" //正品星球
let GDAppKey = "73dcd0051605f829b29dccc6a746a676" //操作员
//百度地图
let BaiduAppKey = "I8aQQsCpBqPeYzuAVuhDiRmbXuWnG4T0"


//let kBaseUrl = "http://192.168.1.122:8080"
let kBaseUrl = "http://app.okshenglian.com"


let kHtmlUrl = kBaseUrl + "/smart/wallet#/"
//let kHtmlUrl = "http://192.168.0.171:8080" + "/#/"

let isShowLog : Bool = true
let isDebug : Bool = true
		
