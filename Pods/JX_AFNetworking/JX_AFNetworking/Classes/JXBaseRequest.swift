//
//  JXBaseRequest.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/12.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import AFNetworking

public enum JXRequestMethod : NSInteger{
    case get
    case post
    case put
    case head
    case delete
    
    case unknow
}


open class JXBaseRequest: NSObject{

    ///请求URL
    public var requestUrl : String?
    ///请求参数
    public var param : Dictionary<String, Any>?
    ///请求方式
    public var method : JXRequestMethod = .post
    ///标记
    public var tag : Int = 0
    
    
    var sessionTask : URLSessionTask?
    //func constructingBlock< T : AFMultipartFormData >(formData : [T]) -> T
    
    public typealias constructingBlock = ((_ formData : AFMultipartFormData) -> Void)?
    public typealias successCompletion = ((_ data:Any?, _ message:String) -> ())
    public typealias failureCompletion = ((_ message:String,_ code:JXNetworkError) -> ())
    
    public var success : successCompletion?
    public var failure : failureCompletion?
    
    ///开始请求
    public func startRequest() {
        JXNetworkManager.manager.buildRequest(self)
    }
    ///停止请求
    public func stopRequest() {
        JXNetworkManager.manager.cancelRequest(self)
    }
    
    

    /// 网络请求
    ///
    /// - Parameters:
    ///   - tag: 暂时用来标记 来源，区别不同的域名，导致不同的数据格式
    ///   - method: 请求方式
    ///   - url: 请求URL
    ///   - param: 请求参数
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public class func request(tag:Int = 0, method:JXRequestMethod = .post, url:String, param:Dictionary<String, Any>?,success:@escaping successCompletion,failure:@escaping failureCompletion) {
        
        let request = self.init(tag: tag, url: url, param: param, success: success, failure: failure)
        
        request.startRequest()
    }
    
    override init() {
        super.init()
    }
    
    required public init(tag:Int, url:String, param:Dictionary<String, Any>?, success:@escaping successCompletion, failure:@escaping failureCompletion) {
        
        self.tag = tag
        self.requestUrl = url
        self.param = param
        
        self.success = success
        self.failure = failure
        
        super.init()
    }

    //子类需重写实现
    open func baseUrl() -> String? {return nil}
    open func customConstruct() -> constructingBlock?  {return nil}
    open func buildCustomUrlRequest() -> URLRequest?  {return nil}
    open func requestSuccess(responseData: Any) {}
    open func requestFailure(error: Error) {}
    
}

extension JXBaseRequest {
    public func responseHeaders() -> [AnyHashable : Any]{
        guard let response = self.sessionTask?.response as? HTTPURLResponse else {
            return [AnyHashable : Any]()
        }
        return response.allHeaderFields 
    }
    
    public func statusCode() -> Int {
        guard let response = self.sessionTask?.response as? HTTPURLResponse else {
            return 404
        }
        return response.statusCode
    }
    
    public func statusCodeValidate() -> Bool {
        let code = self.statusCode()
        
        if code >= 200 && code <= 299 {
            return true
        } else {
            return false
        }
    }
    
}
