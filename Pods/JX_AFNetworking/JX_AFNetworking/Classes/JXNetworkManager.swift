//
//  JXNetworkManager.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/12.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import AFNetworking

public class JXNetworkManager: NSObject {
    //AFNetworking manager
    public var afmanager = AFHTTPSessionManager()
    //request 缓存
    public var requestCache = [String:JXBaseRequest]()
    //网络状态
    public var networkStatus : AFNetworkReachabilityStatus = .reachableViaWiFi
    
    
    //单例
    public static let manager = JXNetworkManager()
    
    public override init() {
        super.init()
        //返回数据格式AFHTTPResponseSerializer(http) AFJSONResponseSerializer(json) AFXMLDocumentResponseSerializer ...
        afmanager.responseSerializer = AFHTTPResponseSerializer.init()
        afmanager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html","application/json","text/json") as? Set<String>
        
        afmanager.operationQueue.maxConcurrentOperationCount = 5
        //请求参数格式AFHTTPRequestSerializer（http） AFJSONRequestSerializer(json) AFPropertyListRequestSerializer (plist)
        afmanager.requestSerializer = AFHTTPRequestSerializer.init()
        afmanager.requestSerializer.timeoutInterval = 10
        
        //set header
        //afmanager.requestSerializer.setValue("3.0.1", forHTTPHeaderField: "version")
        
        
        afmanager.reachabilityManager = AFNetworkReachabilityManager.shared()
        //很大概率，切换网络时，监听不到，不能实时修改状态
        afmanager.reachabilityManager.setReachabilityStatusChange { (status:AFNetworkReachabilityStatus) in
            print("网络状态变化 == \(status.rawValue)")
            self.networkStatus = AFNetworkReachabilityStatus(rawValue: status.rawValue)!
        }
        afmanager.reachabilityManager.startMonitoring()
    }

    public func buildRequest(_ request:JXBaseRequest) {
        print("网络状态 = ",AFNetworkReachabilityManager.shared().isReachable)
        //afmanager.reachabilityManager.startMonitoring()
        ///网络判断
        if networkStatus == .unknown || networkStatus == .notReachable {
            print("网络不可用")
//            let error = NSError.init(domain: "网络连接断开", code: JXNetworkError.kRequestErrorNotConnectedToInternet.rawValue, userInfo: nil)
//            request.requestFailure(error: error)
//            return
        }
        
        ///获取URL
        guard let url = buildUrl(request: request) else {
            let error = NSError.init(domain: "URL构建失败", code: JXNetworkError.kRequestUrlInitFailed.rawValue, userInfo: nil)
            request.requestFailure(error: error)
            return
        }
        
        
        if let customUrlRequest = request.buildCustomUrlRequest() {
            request.sessionTask = afmanager.dataTask(with: customUrlRequest, uploadProgress: nil, downloadProgress: nil, completionHandler: { (response, responseData, error) in
                //
                self.handleTask(task: nil, data: responseData, error: error)
            })
        }else{
            switch request.method {
            case .get:
                request.sessionTask = afmanager.get(url, parameters: request.param, progress: nil, success: { (task:URLSessionDataTask, responseData:Any?) in
                    self.handleTask(task: task, data: responseData, error: nil)
                }, failure: { (task:URLSessionDataTask?, error:Error) in
                    self.handleTask(task: task, data: nil, error: error)
                })
            case .post:
                if let constructBlock = request.customConstruct(), constructBlock != nil{
                    request.sessionTask = afmanager.post(url, parameters: request.param, constructingBodyWith: constructBlock, progress: nil, success: { (task:URLSessionDataTask, responseData:Any?) in
                        self.handleTask(task: task, data: responseData, error: nil)
                    }, failure: { (task:URLSessionDataTask?, error:Error) in
                        self.handleTask(task: task, data: nil, error: error)
                    })
                }else{
                    request.sessionTask = afmanager.post(url, parameters: request.param, progress: nil, success: { (task:URLSessionDataTask, responseData:Any?) in
                        self.handleTask(task: task, data: responseData)
                    }, failure: { (task:URLSessionDataTask?, error:Error) in
                        self.handleTask(task: task, error: error)
                    })
                }
            case .delete:
                request.sessionTask = afmanager.delete(url, parameters: request.param, success: { (task:URLSessionDataTask, responseData:Any?) in
                    self.handleTask(task: task, data: responseData)
                }, failure: { (task:URLSessionDataTask?, error:Error) in
                    self.handleTask(task: task, error: error)
                })
            case .put:
                request.sessionTask = afmanager.put(url, parameters: request.param, success: { (task:URLSessionDataTask, responseData:Any?) in
                    self.handleTask(task: task, data: responseData)
                }, failure: { (task:URLSessionDataTask?, error:Error) in
                    self.handleTask(task: task, error: error)
                })
            case .head:
                request.sessionTask = afmanager.head(url, parameters: request.param, success: { (task:URLSessionDataTask) in
                    self.handleTask(task: task, data: nil)
                }, failure: { (task:URLSessionDataTask?, error:Error) in
                    self.handleTask(task: task, error: error)
                })
            default:
                assert(request.method == .unknow, "请求类型未知")
                break
            }
        }
        
        
        
        addRequest(request: request)
    }
    
}
//MARK: request add remove resume cancel
extension JXNetworkManager {
    
    /// 缓存request
    ///
    /// - Parameter request: 已经包装好含有URL，param的request
    public func addRequest(request:JXBaseRequest) {
        
        guard let task = request.sessionTask
               else {
            return
        }
        let key = requestHashKey(task: task)
        requestCache[key] = request
    }
    
    /// 删除缓存中request
    ///
    /// - Parameter request: 已经包装好含有URL，param的request
    public func removeRequest(_ request:JXBaseRequest) {
        guard let task = request.sessionTask
            else {
                return
        }
        let key = requestHashKey(task: task)
        requestCache.removeValue(forKey: key)
    }
    
    /// 取消request
    ///
    /// - Parameter request: 已经包装好含有URL，param的request
    public func cancelRequest(_ request:JXBaseRequest) {
        guard (request.sessionTask as? URLSessionDataTask) != nil
            else {
                return
        }
        request.sessionTask?.cancel()
        removeRequest(request)
    }
    /// 取消所有request
    public func cancelRequests(keepCurrent request:JXBaseRequest? = nil) {
        
        for (_,r) in requestCache {
            if let current = request, current == r{
                //保留当前请求
            } else {
                cancelRequest(r)
            }
        }
    }
    /// 重发request
    ///
    /// - Parameter request: 已经包装好含有URL，param的request
    public func resumeRequest(_ request:JXBaseRequest) {
        buildRequest(request)
    }
    /// 重发所有缓冲中的request
    ///
    /// - Parameter request: 已经包装好含有URL，param的request
    public func resumeRequests(except request:JXBaseRequest) {
        for (_,value) in requestCache {
            let r = value as JXBaseRequest
            if r == request {
                //不作处理
            } else {
                removeRequest(r)
                resumeRequest(r)
            }
        }
    }
}

extension JXNetworkManager{
    /// 对请求任务hash处理
    ///
    /// - Parameter task: 当前请求task
    /// - Returns: hash后的字符串
    public func requestHashKey(task:URLSessionTask) -> String {
        return String(format: "%lu", task.hash)
    }
}

extension JXNetworkManager {
    
    public func buildUrl(request:JXBaseRequest) -> String? {
        
        guard let url = request.requestUrl else {
            fatalError("request URL can not be nil")
        }
        
        if url.hasPrefix("http") == true{
            return url
        }
        guard let baseUrl = request.baseUrl() else {
            fatalError("please set baseUrl in your custom request class")
        }
        let wholeUrl = baseUrl + url
        let encodingUrl = wholeUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodingUrl
    }
}
//MARK: 结果处理 response handle
extension JXNetworkManager {
    
    public func handleTask(task:URLSessionDataTask?, data:Any? = nil, error:Error? = nil) {
        ///
        guard let task = task else { return}
        //
        let key = requestHashKey(task: task)
        guard let request = requestCache[key] else { return}
     
        if checkResult(request: request) == true && error == nil{
            request.requestSuccess(responseData: data!)
        } else {
            request.requestFailure(error: error!)
        }

        requestCache.removeValue(forKey: key)
    }
    
    public func checkResult(request:JXBaseRequest) -> Bool {
        let result = request.statusCodeValidate()
        return result
    }
   
}

extension JXNetworkManager {
    
}
