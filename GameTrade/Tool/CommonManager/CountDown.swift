//
//  CountDown.swift
//  JXFoundation_Example
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class CountDown: NSObject {

    lazy var timer: DispatchSourceTimer = {
        let queue = DispatchQueue.global(qos: .default)
        let t = DispatchSource.makeTimerSource(flags: [], queue: queue)
        return t
    }()
    lazy var formatter: DateFormatter = {
        let format = DateFormatter()
        return format
    }()
    var tableView : UITableView?
    var dataArray : Array<BaseModel>? {
        didSet {
            //self.timer.cancel()
            self.count = 0
            self.countDown()
        }
    }
    
    var count : Int = 0
    
    var completionBlock : ((_ indexPath: IndexPath)->())?
    
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(setupLess), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    init(tableView: UITableView, data: Array<BaseModel>) {
        super.init()
        
        self.tableView = tableView
        self.dataArray = data
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupLess), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.countDown()
    }
    
    @objc func setupLess() {
        
    }
    func countDown() {
    
        self.timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: 1)
        self.timer.setEventHandler {
            DispatchQueue.main.async {
                self.count += 1
                
                if var arr = self.dataArray {
                    for i in 0..<arr.count {
                        if let entity = arr[i] as? OrderEntity, entity.expireTime > 0 {
                            var num = entity.expireTime
                            num -= 1
                            entity.expireTime = num
//                            //测试用
//                            if num % 30 == 0 {
//                                entity.orderStatus = 6
//                            }
                            if num == 0 {
                                entity.orderStatus = 6
                            }
                            if let index = arr.index(of: entity) {
                                arr[index] = entity
                                //print(entity.expireTime)
                            }
                        }
                    }
                }
                
                
                
//                self.dataArray?.forEach({ (entity: inout BaseModel) in
//                    let e = entity as? OrderEntity
//                    var num = e?.expireTime
//                    num -= 1
//                    if let index = self.dataArray?.index(of: entity) {
//                        self.dataArray?[index] = e
//                    }
//                })
                self.tableView?.visibleCells.forEach({ (cell) in
                    if let view = cell.viewWithTag(1314), let button = view as? UIButton {
                        
                        let entity = self.dataArray?[cell.tag] as? OrderEntity
                        let timeNum = entity?.expireTime ?? 0
                        //let timeNum = self.dataArray?[cell.tag] ?? 0
                        print("----",timeNum)
                        
                        if let type = entity?.orderType, type == "购买"{
                            if timeNum >= 0 {
                                //测试用
//                                if timeNum % 30 == 0 {
//                                    //entity.orderStatus = 6
//                                    if let block = self.completionBlock {
//                                        let indexPath = IndexPath(row: cell.tag, section: 0)
//                                        block(indexPath)
//                                    }
//                                }
                                if timeNum == 0 {
                                    if let block = self.completionBlock {
                                        let indexPath = IndexPath(row: cell.tag, section: 0)
                                        block(indexPath)
                                    }
                                }
                                let str = self.getCountDownFormatStr(timeInterval: timeNum)
                                button.setTitle(self.getCountDownCustomStr(str: str), for: .normal)
                                
                            } else {
                                //button.setTitle("还剩(\(self.getCountDownStr(timeInterval: timeNum)))", for: .normal)
                                print("已结束")
                            }
                        } else {
                            //self.MerchantNameLabel.textColor = JXGreenColor
                        }
                        
                    }
                })
            }
        }
        self.timer.resume()
    }
    func countDown(indexPath: IndexPath) -> String {
        let entity = self.dataArray?[indexPath.row] as? OrderEntity
        let timeNum = entity?.expireTime ?? 0
        let str = self.getCountDownFormatStr(timeInterval: timeNum)
        return self.getCountDownCustomStr(str: str)
    }
    func getCountDownFormatStr(timeInterval: Int) -> String {
        if timeInterval <= 0 {
            return ""
        }
        let days = timeInterval / (3600 * 24)
        let hours = (timeInterval - days * 24 * 3600) / 3600
        let minutes = (timeInterval - days * 24 * 3600 - hours * 3600) / 60
        let seconds = timeInterval - days * 24 * 3600 - hours * 3600 - minutes * 60
        
        var dayStr : String = ""
        var hourStr : String = ""
        var minuteStr : String = ""
        var secondStr : String = ""
        
        if minutes < 10 {
            minuteStr = String(format: "0%d", minutes)
        } else {
            minuteStr = String(format: "%d", minutes)
        }
        if seconds < 10 {
            secondStr = String(format: "0%d", minutes)
        } else {
            secondStr = String(format: "%d", minutes)
        }
        if minutes < 10 {
            minuteStr = String(format: "0%d", minutes)
        } else {
            minuteStr = String(format: "%d", minutes)
        }
        
        var timeStr : String = ""
        if days > 0 {
            timeStr = String(format: "%zd天%zd小时%zd分%zd秒", days,hours,minutes,seconds)
        } else {
            if hours > 0 {
                timeStr =  String(format: "%zd小时%zd分%zd秒", hours,minutes,seconds)
            } else {
                if minutes > 0 {
                    timeStr =  String(format: "%zd分%zd秒", minutes,seconds)
                } else {
                    timeStr =  String(format: "%zd秒", seconds)
                }
            }
        }
        return timeStr
    }
    func getCountDownCustomStr(str: String) -> String {
        if str.isEmpty {
            return ""
        }
        return "还剩(\(str))"
    }
   
    deinit {
        timer.cancel()
    }
}
