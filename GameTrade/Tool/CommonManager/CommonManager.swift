//
//  CommonManager.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import Foundation

class CommonManager {
    static let manager = CommonManager()
    
    private init() {
        
    }
    /// 倒计时
    ///
    /// - Parameters:
    ///   - timeOut: 倒计时长(执行次数)
    ///   - timeInterval: 倒计时间间隔(每次调用间隔)
    ///   - process:未完成时的回调
    ///   - completion: 完成回调
    static func countDown(timeOut:Int,timeInterval:Double = 1,process:@escaping ((_ currentTime:Int)->()),completion:@escaping (()->())) {
        
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
    }
    
    /// 倒计时
    ///
    /// - Parameters:
    ///   - timeOut: 倒计时长(执行次数)
    ///   - timeInterval: 倒计时间间隔(每次调用间隔)
    ///   - process:未完成时的回调
    ///   - completion: 完成回调
    static func countDown1(timeOut:Int,timeInterval:Double = 1,process:@escaping ((_ currentTime:Int)->()),completion:@escaping (()->())) -> DispatchSourceTimer{
        
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
}
