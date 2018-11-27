//
//  CommonManager.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

/// 打印信息
///
/// - Parameters:
///   - msg: 要输出的信息
///   - file: 文件名
///   - line: 方法所在行数
///   - function: 方法名称
public func prints<T>(_ msg:T, file: String = #file, line: Int = #line, function: String = #function) {
    
    if JXConstantHelper.shared.isShowLog {
        let fileName = (file as NSString).lastPathComponent.components(separatedBy: ".")[0]
        Swift.print(fileName,msg, separator: " ", terminator: "\n")
    }
    //print("[\(Date(timeIntervalSinceNow: 0))]",msg, separator: " ", terminator: "\n")
    //print("\(Date(timeIntervalSinceNow: 0)) <\(fileName) \(line) \(function)>\n\(msg)", separator: "", terminator: "\n")
}

class JXFoundationHelper {
    static let shared = JXFoundationHelper()
    
    private init() {}
    /// 倒计时
    ///
    /// - Parameters:
    ///   - timeOut: 倒计时长(执行次数)
    ///   - timeInterval: 倒计时间间隔(每次调用间隔)
    ///   - process:未完成时的回调
    ///   - completion: 完成回调
    public func countDown(timeOut: Int, timeInterval: Double = 1, process: @escaping ((_ currentTime: Int)->()), completion: @escaping (()->())) -> DispatchSourceTimer{
        
        var timeOut1 = timeOut
        let queue = DispatchQueue.global(qos: .default)
        let source_timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        source_timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: timeInterval)
        source_timer.setEventHandler {
            if timeOut1 <= 0 {
                source_timer.cancel()
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                let seconds = timeOut1 % (timeOut + 1)
                DispatchQueue.main.async {
                    process(seconds)
                }
                timeOut1 -= 1
            }
        }
        source_timer.resume()
        return source_timer
    }
   
    /// 校验字符串
    ///
    /// - Parameters:
    ///   - string: 需要校验的字符串
    ///   - predicateStr: 正则
    ///   - emptyMsg: 空字串提示
    ///   - formatMsg: 格式错误提示
    /// - Returns: 结果
    public func validate(_ string: String?, predicateStr: String, emptyMsg: String?, formatMsg: String) -> Bool{
        guard let str = string, str.isEmpty == false else {
            let notice = JXNoticeView.init(text: emptyMsg ?? formatMsg)
            notice.show()
            return false
        }
        if predicateStr.isEmpty {
            return true
        }
        if !String.validate(str, predicateStr: predicateStr) {
            let notice = JXNoticeView.init(text: formatMsg)
            notice.show()
            return false
        } else {
            return true
        }
    }
    
}
