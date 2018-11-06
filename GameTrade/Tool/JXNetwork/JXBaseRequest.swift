//
//  JXBaseRequest.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/12.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit
import AFNetworking

enum JXRequestMethod : NSInteger{
    case get
    case post
    case put
    case head
    case delete
    
    case unknow
}


class JXBaseRequest: NSObject {

    ///请求URL
    var requestUrl : String?
    ///请求参数
    var param : Dictionary<String, Any>?
    ///请求方式
    var method : JXRequestMethod = .post
    ///标记
    var tag : Int = 0
    
    
    var sessionTask : URLSessionTask?
    //func constructingBlock< T : AFMultipartFormData >(formData : [T]) -> T
    
    typealias ConstructingBlock = ((_ formData : AFMultipartFormData) -> Void)?
    typealias SuccessCompletion = ((_ data: Any?, _ message: String) -> ())
    typealias FailureCompletion = ((_ message: String, _ code: JXNetworkError) -> ())
    
    typealias DownloadCompletion = ((_ response: URLResponse, _ url: URL?, _ error: Error?) -> ())
    typealias Destination = ((_ url: URL, _ urlResponse: URLResponse) -> (URL))
    typealias DownloadProgress = ((_ progress: Progress) -> ())
    
    
    var success : SuccessCompletion?
    var failure : FailureCompletion?
    
    var download : DownloadCompletion?
    var destination : Destination?
    var progress : DownloadProgress?
    
    ///开始请求
    func startRequest() {
        //
        JXNetworkManager.manager.buildRequest(self)
    }
    ///停止请求
    func stopRequest() {
        //
        JXNetworkManager.manager.cancelRequest(self)
    }
    
    var urlRequest : URLRequest?

    func startDownload() {
        JXNetworkManager.manager.download(self)
    }
    func stopDownload() {
        JXNetworkManager.manager.download(self)
    }
    func pauseDownload() {
        JXNetworkManager.manager.download(self)
    }
    func resumeDownload() {
        
    }
    
    class func download(urlStr: String, destination: @escaping Destination,progress:@escaping DownloadProgress, download: @escaping DownloadCompletion) {
        
        let request = self.init(tag: 0, url: urlStr, method: .post, param: nil, success: nil, failure: nil, progress: progress, download: download, destination: destination)
       
        request.startDownload()
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
    class func request(tag: Int = 0, method: JXRequestMethod = .post, url: String, param: Dictionary<String, Any>?, success: @escaping SuccessCompletion, failure: @escaping FailureCompletion) {
        
        let request = self.init(tag: tag, url: url, method: method, param: param, success: success, failure: failure, progress: nil, download: nil, destination: nil)
        
        request.startRequest()
    }
    
    override init() {
        super.init()
    }
    
    required init(tag: Int, url: String, method: JXRequestMethod, param: Dictionary<String, Any>?, success: SuccessCompletion?, failure: FailureCompletion?, progress: DownloadProgress?, download: DownloadCompletion?, destination: Destination?) {
        
        self.tag = tag
        self.requestUrl = url
        self.method = method
        self.param = param
        self.success = success
        self.failure = failure
        //下载
        self.download = download
        self.progress = progress
        self.destination = destination
        
        super.init()
    }
    
   
    //子类实现
    func customConstruct() -> ConstructingBlock?  {return nil}
    func buildCustomUrlRequest() -> URLRequest?  {return nil}
    func requestSuccess(responseData:Any) {}
    func requestFailure(error: Error) {}
    
}

extension JXBaseRequest {
    func responseHeaders() -> [AnyHashable : Any]{
        guard let response = self.sessionTask?.response as? HTTPURLResponse else {
            return [AnyHashable : Any]()
        }
        return response.allHeaderFields 
    }
    
    func statusCode() -> Int {
        guard let response = self.sessionTask?.response as? HTTPURLResponse else {
            return 404
        }
        return response.statusCode
    }
    
    func statusCodeValidate() -> Bool {
        let code = self.statusCode()
        
        if code >= 200 && code <= 299 {
            return true
        } else {
            return false
        }
    }
    
}
