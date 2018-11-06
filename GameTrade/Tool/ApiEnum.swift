
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
    
    case buyList =                   "/planA/agent/adList"                 //买单列表
    case buyQuick =                  "/planA/order/fastBuy"                //快捷购买
    case buyNormal =                 "/planA/order/adBuy"                  //普通购买
    
    case merchantDetail =            "/planA/agent/detail"                 //币商详情
    
    //用户
    case sellList =                  "/planA/ad/list"                      //卖单列表
    case sellCreate =                "/planA/ad/create"                    //卖单创建
    
    case transferCoin =              "/planA/wallet/transfer"              //发币
    
    
    
    case orderList =                 "/planA/order/list"                   //订单列表
    case orderDetail =               "/planA/order/detail"                 //订单详情
    
    case buyCancel =                 "/planA/order/cancel"                 //买单取消
    case buyConfirm =                "/planA/order/payConfirm"             //买单付款确认
    case sellCancel =                "/planA/ad/delete"                    //卖单取消
    case sellConfirm =               "/planA/order/receiptConfirm"         //卖单付款确认
    
    case tradeList =                 "/planA/wallet/recordList"            //交易列表
    case tradeDetail =               "/planA/wallet/recordDetail"          //交易详情
    
    
    case harvestDiamond =            "/planA/home/takeMineral"             //收获水晶
    case inviteInfo =                "/planA/user/inviteInfo"              //邀请好友页面，包含我的邀请码，累计获得ipe数量等
    
    case taskList =                  "/planA/user/powerTask"               //提升智慧页面,包含未完成任务
    case taskRecord =                "/planA/fixedTask/record"             //固定任务完成记录
    
    case property  =                 "/planA/user/ipeInfo"                 //我的资产
    case propertyRecord =            "/planA/user/coinRecord"              //资产记录
    
    case powerRecord =               "/planA/user/powerRecord"             //算力记录
    
    case liveAuth =                  "/planA/fixedTask/faceAuth"           //人脸身份识别
    
    case weChat =                    "/planA/fixedTask/wechatSubscribe"    //关注公众号验证码验证
    case createWallet =              "/planA/fixedTask/createWallet"       //创建链上钱包
    case copyWallet  =               "/planA/fixedTask/backupWallet"       //备份链上钱包
    case myProperty  =               "/planA/my/asset"                     //我的资产
    
    case profileInfo =               "/planA/user/baseInfo"                //我的基础信息 ，昵称，头像，注册排行
    case myIdentity  =               "/planA/user/identityInfo"            //我的实名信息
    case modifyNickName  =           "/planA/user/updateNickname"          //修改昵称
    case modifyAvatar  =             "/planA/user/updateHeadImg"           //修改头像
    case payList  =                  "/planA/depositAccounts/list"         //支付方式列表
    case bankList  =                 "/planA/depositAccounts/bankList"     //银行列表
    case editPayStyle  =             "/planA/depositAccounts/save"         //添加、修改支付方式
    case deletePayStyle  =           "/planA/depositAccounts/delete"       //删除支付方式
    
    case feedBack  =                 "/planA/common/suggestSubmit"         //反馈
    
    case modifyLogPsdSendCode =      "/planA/user/updateLoginPwd/sendMobileCode" //修改登录密码发送验证码
    case modifyLogPsd =              "/planA/user/updateLoginPwd/doUpdate" //修改登录密码
    case modifyTradePsdSendCode =    "/planA/user/updateSafePwd/sendMobileCode" //修改资金密码发送验证码
    case modifyTradePsdValidateCode = "/planA/user/updateSafePwd/validateMobileCode"//修改资金密码校验验证码
    case modifyTradePsd =            "/planA/user/updateSafePwd/doUpdate"  //修改资金密码
    
    case tradePsdInit =              "/planA/user/safePwdInit"             //资金密码初始化
    
    case articleList =               "/planA/article/list"                 //文章列表
    case articleDetails  =           "/planA/article/detail"               //文章详情
    case articleLike =               "/planA/article/like"                 //文章点赞，不允许取消
    case articleRead =               "/planA/article/read"                 //阅读任务
    case articleCommentList =        "/planA/article/commentList"          //评论列表
    case articleComment =            "/planA/article/comment"              //发表评论
    case articleCommentDelete =      "/planA/article/deleteComment"        //删除评论
    case articelQueryByBlockChain =  "/planA/article/chainInfo"            //查看文章上链信息
    
    case paperList  =                "/planA/thesis/list"                  //论文列表
    case paperDetail  =              "/planA/thesis/detail"                //论文详情
    case paperTrade   =              "/planA/thesis/trade"                 //论文购买
    
    case modifiyPwd       = "/user/updatePassword"
    case personInfo       = "/user/realInfo"

}
