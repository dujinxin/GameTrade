//
//  OrderView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderView: UIView {
    
    lazy var mainView: UIView = {
        let v = UIView()
        v.backgroundColor = JXBackColor
        return v
    }()
    lazy var merchatImageView: UILabel = {
//        let v = UIImageView()
//        v.layer.cornerRadius = 20
//        v.layer.masksToBounds = true
//        v.clipsToBounds = true
//        v.backgroundColor = JXOrangeColor
        let v = UILabel()
        v.textColor = UIColor.rgbColor(rgbValue: 0x222133)
        v.font = UIFont.systemFont(ofSize: 20)
        v.textAlignment = .center
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x2f2f3d)
        v.layer.cornerRadius = 20
        v.layer.masksToBounds = true
        return v
    }()
    
    
    lazy var merchatNameLabel: UILabel = {
        let v = UILabel()
        v.textColor = JXTextColor
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .left
        return v
    }()
    lazy var timeLabel: UILabel = {
        let v = UILabel()
        v.textColor = JXTextColor
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .right
        return v
    }()
    lazy var worthLabel: UILabel = {
        let v = UILabel()
        v.textColor = JXTextColor
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .left
        return v
    }()
    lazy var statusLabel: UILabel = {
        let v = UILabel()
        v.textColor = JXOrangeColor
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .right
        return v
    }()
    
    var timer : DispatchSourceTimer?
    var timeOutBlock : (()->())?
    
    var entity: OrderDetailEntity? {
        
        didSet{
            //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
            if entity?.orderStatus == 1 {
                self.statusLabel.text = "待付款"
            } else if entity?.orderStatus == 2 {
                self.statusLabel.text = "待卖家确认"
            } else if entity?.orderStatus == 3 {
                self.statusLabel.text = "已完成"
            } else {
                self.statusLabel.text = "已关闭"
            }
            
            self.merchatImageView.text = String(entity?.agentName?.prefix(1) ?? "")
            self.merchatNameLabel.text = entity?.agentName
            //self.timeLabel.text = "交易数量：\(entity?.coinCounts ?? 0)\(configuration_coinName)"
            self.worthLabel.text = "交易总额：\(entity?.payAmount ?? 0) \(configuration_valueType)"

            var timeInter = 0
            if let type = entity?.orderType, type == "出售" {
                timeInter = entity?.receiveExpireTime ?? 0
            }
            
            if timeInter > 0 {
                self.timer = CommonManager.countDown1(timeOut: timeInter, process: { (process) in

                    let str = self.getCountDownFormatStr(timeInterval: process)
                    self.timeLabel.text = self.getCountDownCustomStr(str: str)
                }) {
                    self.statusLabel.text = "已关闭"
                    if let block = self.timeOutBlock {
                        block()
                    }
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.mainView)
        self.mainView.addSubview(self.merchatImageView)
        self.mainView.addSubview(self.merchatNameLabel)
        self.mainView.addSubview(self.timeLabel)
        self.mainView.addSubview(self.worthLabel)
        self.mainView.addSubview(self.statusLabel)
        
        
        self.mainView.backgroundColor = JXBackColor
        self.mainView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.mainView.layer.shadowOpacity = 1
        self.mainView.layer.shadowRadius = 33
        self.mainView.layer.shadowColor = JX22222cShadowColor.cgColor
        self.mainView.layer.cornerRadius = 4
        
        
        self.merchatNameLabel.text = "昵称"
        self.timeLabel.text = "" //"2018-11-07 14:20"
        self.worthLabel.text = "订单金额：5410.46"
        self.statusLabel.text = "未付款"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.mainView.frame = CGRect(x: 24, y: 8, width: bounds.width - 24 * 2, height: bounds.height - 24)
        self.merchatImageView.frame = CGRect(x: 16, y: 16, width: 40, height: 40)
        self.timeLabel.frame = CGRect(x: mainView.jxWidth - 16 - 80, y: 0, width: 80, height: 18)
        self.timeLabel.center.y = self.merchatImageView.center.y
        self.merchatNameLabel.frame = CGRect(x: merchatImageView.jxRight + 16, y: 0, width: mainView.jxWidth - merchatImageView.jxWidth - timeLabel.jxWidth - 16 * 3, height: 20)
        self.merchatNameLabel.center.y = self.merchatImageView.center.y
        
        
        self.worthLabel.frame = CGRect(x: 16, y: merchatImageView.jxBottom + 18, width: 200, height: 18)
        self.statusLabel.frame = CGRect(x: worthLabel.jxRight + 10, y: 0, width: 80, height: 18)
        self.statusLabel.center.y = self.worthLabel.center.y
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
        return "\(str)"
    }
}
