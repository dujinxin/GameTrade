//
//  JXNetworkError.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/23.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import Foundation

public enum JXNetworkError : Int {
    
    case kResponseSuccess                 = 0  //成功
    case kResponseFailed                  = 1  //失败
    case kResponseShortTokenDisabled      = 3  //token过期
    case kResponseLongTokenDisabled       = 4  //长token失效
    case kResponseLoginFromOtherDevice    = 5  //在其他设备登录
    
    case kRequestUrlInitFailed = 50   //URL构建失败
    
    case kResponseUnknow              = 203
    case kResponseDeliverTagNotEnough = 204
    
    
    case kResponseDataError = 3840    /*数据有误*/
    
    // Error codes for CFURLConnection and CFURLProtocol
    case kRequestErrorUnknown = -998                                  /*请求超时*/
    case kRequestErrorCancelled = -999
    case kRequestErrorBadURL = -1000
    case kRequestErrorTimedOut = -1001                                /*请求超时*/
    case kRequestErrorUnsupportedURL = -1002
    case kRequestErrorCannotFindHost = -1003                          /*未能找到服务器*/
    case kRequestErrorCannotConnectToHost = -1004                     /*未能连接到服务器*/
    case kRequestErrorNetworkConnectionLost = -1005
    case kRequestErrorDNSLookupFailed = -1006
    case kRequestErrorHTTPTooManyRedirects = -1007
    case kRequestErrorResourceUnavailable = -1008
    case kRequestErrorNotConnectedToInternet = -1009                  /*网络连接断开*/
    
    case kRequestErrorBadServerResponse = 		-1011
    
}

public let kRequestTimeOutDomain = "网络请求超时"
public let kRequestNetworkLostDomain = "网络连接断开"
public let kRequestNotConnectedDomain = "网络连接异常"
public let kRequestResourceUnavailableDomain = "网络数据异常"
public let kRequestResourceDataErrorDomain = "HT数据异常"
