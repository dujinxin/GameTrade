
//
//  ApiEnum.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/9.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import Foundation

enum ApiString : String {
    
    case getImageCode =              "/planA/validateCode"                 //获取图片验证码 注册、登录时发送短信验证码需要
    case sendMobileCodeRegister =    "/planA/register/sendMobileCode"      //注册时发送短信验证码
    case sendMobileCodeLogin   =     "/planA/login/sendMobileCode"         //登录时发送短信验证码
    case sendMobileCodeForgotPwd   = "/planA/user/resetPwd/sendMobileCode" //找回密码时发送短信验证码
    
    case login =                     "/planA/login"                        //用户登录
    case logout =                    "/planA/logout"                       //用户登出
    case register =                  "/planA/register/doRegister"          //用户注册
    case resetPsd =                  "/planA/user/resetPwd/doReset"        //重设密码
    
    case identityAuth =              "/planA/register/identityAuth"        //身份证+姓名认证
    
    case homeInfo =                  "/planA/home/homeInfo"                //首页
    case homeNotice =                "/planA/common/notice"                //公告
    
    case scanPayGetInfo =            "/planA/order/prePay"                 //获取支付信息
    case scanPay =                   "/planA/order/scanPay"                //扫码支付
    
    case buyList =                   "/planA/agent/adList"                 //买单列表
    case getQuickPayType =           "/planA/order/getFastBuyPayType"      //快捷购买支持的支付方式
    case buyQuick =                  "/planA/order/fastBuy"                //快捷购买
    case buyNormal =                 "/planA/order/adBuy"                  //普通购买
    
    case merchantDetail =            "/planA/agent/detail"                 //币商详情
    
    //用户
    case sellList =                  "/planA/ad/list"                      //卖单列表
    case sellInfo =                  "/planA/ad/accountInfo"               //余额，收款账户查询
    case sellCreate =                "/planA/ad/create"                    //卖单创建
    case sellDelete =                "/planA/ad/delete"                    //卖单删除
    
    case transferCoin =              "/planA/wallet/transfer"              //发币
    
    
    
    case orderList =                 "/planA/order/list"                   //订单列表
    case orderDetail =               "/planA/order/detail"                 //订单详情
    
    case getChatID =                 "/planA/common/getServiceId"          //获取会话ID
    
    case buyCancel =                 "/planA/order/cancel"                 //买单取消
    case buyConfirm =                "/planA/order/payConfirm"             //买单付款确认
    
    case sellConfirm =               "/planA/order/receiptConfirm"         //卖单付款确认
 
    
    case profileInfo =               "/planA/user/baseInfo"                //我的基础信息 ，昵称，头像，注册排行
    case myIdentity  =               "/planA/user/identityInfo"            //我的实名信息
    case modifyNickName  =           "/planA/user/updateNickname"          //修改昵称
    case modifyAvatar  =             "/planA/user/updateHeadImg"           //修改头像
    case addName  =                  "/planA/user/updateRealName"          //添加实名
    case payList  =                  "/planA/depositAccounts/list"         //支付方式列表
    case bankList  =                 "/planA/depositAccounts/bankList"     //银行列表
    case validateTradePassword  =    "/planA/depositAccounts/validateSafePassword" //验证资金密码
    case editPayStyle  =             "/planA/depositAccounts/save"         //添加、修改支付方式
    case deletePayStyle  =           "/planA/depositAccounts/delete"       //删除支付方式
    
    case feedBack  =                 "/planA/common/suggestSubmit"         //反馈
    case version  =                  "/planA/common/appVersion"            //版本信息
    
    
    case tradeList =                 "/planA/wallet/recordList"            //交易列表
    case tradeDetail =               "/planA/wallet/recordDetail"          //交易详情

    
    
    case modifyLogPsdSendCode =      "/planA/user/updateLoginPwd/sendMobileCode" //修改登录密码发送验证码
    case modifyLogPsd =              "/planA/user/updateLoginPwd/doUpdate" //修改登录密码
    case modifyTradePsdSendCode =    "/planA/user/updateSafePwd/sendMobileCode" //修改资金密码发送验证码
    case modifyTradePsdValidateCode = "/planA/user/updateSafePwd/validateMobileCode"//修改资金密码校验验证码
    case modifyTradePsd =            "/planA/user/updateSafePwd/doUpdate"  //修改资金密码
    
    case tradePsdInit =              "/planA/user/safePwdInit"             //资金密码初始化
}
