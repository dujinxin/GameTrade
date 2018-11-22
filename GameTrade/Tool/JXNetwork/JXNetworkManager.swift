//
//  JXNetworkManager.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/12.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import AFNetworking

class JXNetworkManager: NSObject {
    
    var afmanager = AFHTTPSessionManager()
    
    var requestCache = [String:JXBaseRequest]()
    
    var networkStatus : AFNetworkReachabilityStatus = .reachableViaWiFi
    
    //var userAccound : UserModel?
    
//    var isLogin : Bool {
//        if userAccound == nil {
//            userAccound = UserModel()
//        }
//        return userAccound!.sid != nil
//    }
    
    var sid : String? {
        return ""
    }
    
    
    static let manager = JXNetworkManager()
    
    override init() {
        super.init()
        //返回数据格式AFHTTPResponseSerializer(http) AFJSONResponseSerializer(json) AFXMLDocumentResponseSerializer ...
        afmanager.responseSerializer = AFHTTPResponseSerializer.init()
        afmanager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html","application/json","image/jpeg") as? Set<String>
        
        afmanager.operationQueue.maxConcurrentOperationCount = 5
        //请求参数格式AFHTTPRequestSerializer（http） AFJSONRequestSerializer(json) AFPropertyListRequestSerializer (plist)
        afmanager.requestSerializer = AFHTTPRequestSerializer.init()
        afmanager.requestSerializer.timeoutInterval = 10
        
        afmanager.requestSerializer.setValue(UIDevice.current.uuid, forHTTPHeaderField: "deviceId")
        afmanager.requestSerializer.setValue(UIDevice.current.modelName, forHTTPHeaderField: "device")
        afmanager.requestSerializer.setValue(UIDevice.current.systemName, forHTTPHeaderField: "os")
        afmanager.requestSerializer.setValue(Bundle.main.version, forHTTPHeaderField: "version")
        afmanager.requestSerializer.setValue(kVersion, forHTTPHeaderField: "appVersion")
        afmanager.requestSerializer.setValue(configuration_merchantID, forHTTPHeaderField: "mertId")
        
        
        afmanager.reachabilityManager = AFNetworkReachabilityManager.shared()
        //很大概率，切换网络时，监听不到，不能实时修改状态
        afmanager.reachabilityManager.setReachabilityStatusChange { (status:AFNetworkReachabilityStatus) in
            print("网络状态变化 == \(status.rawValue)")
            self.networkStatus = AFNetworkReachabilityStatus(rawValue: status.rawValue)!
        }
        afmanager.reachabilityManager.startMonitoring()
    }

    func buildRequest(_ request:JXBaseRequest) {
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
        let url = buildUrl(url: request.requestUrl)
        
        
        if UserManager.manager.isLogin == true {
            afmanager.requestSerializer.setValue("planA_sid=\(UserManager.manager.userEntity.planA_sid)", forHTTPHeaderField: "Cookie")
        }else{
            afmanager.requestSerializer.setValue("", forHTTPHeaderField: "Cookie")
        }
        print(afmanager.requestSerializer.httpRequestHeaders)
        
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
                //            afmanager.post(url, parameters: request.param, constructingBodyWith: { (formdata) in
                //                //
                //
                //                let str = NSHomeDirectory() + "/Documents/userImage.jpg"
                //                let url = URL.init(fileURLWithPath: str)
                //                let data = try? Data.init(contentsOf: url)
                //                formdata.appendPart(withFileData: data!, name: "image", fileName: "userImage.jpg", mimeType: "image/jpeg")
                //
                //            }, progress: nil, success: { (task, res) in
                //                //
                //            }, failure: { (task, error) in
                //                //
                //            })
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
    func download(_ request: JXBaseRequest) {
        guard let urlStr = request.requestUrl, let url = URL(string: urlStr)  else {
            fatalError("Bad UrlStr")
        }
        let urlRequest = URLRequest.init(url: url)
        request.urlRequest = urlRequest
        
        guard let destination = request.destination else {
            fatalError("destination block can not be nil")
        }
        request.sessionTask = afmanager.downloadTask(with: urlRequest, progress: request.progress, destination: destination, completionHandler: request.download)
//        request.sessionTask = afmanager.downloadTask(with: urlRequest, progress: { (progress) in
//            print(progress.totalUnitCount,progress.completedUnitCount)
//        }, destination: destination) { (urlResponse, url, error) in
//            print(urlResponse,url,error)
//        }
        request.sessionTask?.resume()
        addRequest(request: request)
        
    }
    
}
//MARK: request add remove resume cancel
extension JXNetworkManager {
    
    /// 缓存request
    ///
    /// - Parameter request: 已经包装好含有URL，param的request
    func addRequest(request:JXBaseRequest) {
        
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
    func removeRequest(_ request:JXBaseRequest) {
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
    func cancelRequest(_ request:JXBaseRequest) {
        guard (request.sessionTask as? URLSessionDataTask) != nil
            else {
                return
        }
        request.sessionTask?.cancel()
        removeRequest(request)
    }
    /// 取消所有request
    func cancelRequests(keepCurrent request:JXBaseRequest? = nil) {
        
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
    func resumeRequest(_ request:JXBaseRequest) {
        buildRequest(request)
    }
    /// 重发所有缓冲中的request
    ///
    /// - Parameter request: 已经包装好含有URL，param的request
    func resumeRequests(_ request:JXBaseRequest) {
        for (_,value) in requestCache {
            let request = value as JXBaseRequest
            
            removeRequest(request)
            resumeRequest(request)
        }
    }
    
}

extension JXNetworkManager{
    /// 对请求任务hash处理
    ///
    /// - Parameter task: 当前请求task
    /// - Returns: hash后的字符串
    func requestHashKey(task:URLSessionTask) -> String {
        return String(format: "%lu", task.hash)
    }
}

extension JXNetworkManager {
    
    func buildUrl(url:String?) -> String {
        
        guard let url = url else {
            return ""
        }
        
        if url.hasPrefix("http") == true{
//            afmanager.requestSerializer = AFJSONRequestSerializer.init()
//            afmanager.requestSerializer.timeoutInterval = 10
//            afmanager.requestSerializer.setValue("ceccm", forHTTPHeaderField: "source")
//            print("afmanager.requestSerializer = \(afmanager.requestSerializer)")
            return url
        }else{
//            afmanager.requestSerializer = AFHTTPRequestSerializer.init()
//            afmanager.requestSerializer.timeoutInterval = 10
        }
       
        let ssss = kBaseUrl + url //"http://192.168.10.12:8086\(url)"
        let sssss = ssss.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        return sssss!
    }
}
//MARK: 结果处理 response handle
extension JXNetworkManager {
    
    func handleTask(task:URLSessionDataTask?, data:Any? = nil, error:Error? = nil) {
        ///
        guard let task = task else {
                return
        }
        //
        let key = requestHashKey(task: task)
        guard let request = requestCache[key] else {
            return
        }
        let succeed = checkResult(request: request)
        
        if succeed && error == nil{
            request.requestSuccess(responseData: data!)
        } else {
            request.requestFailure(error: error!)
        }

        requestCache.removeValue(forKey: key)
    }
    
    func checkResult(request:JXBaseRequest) -> Bool {
        let result = request.statusCodeValidate()
        return result
    }
   
}

extension JXNetworkManager {
    
}
