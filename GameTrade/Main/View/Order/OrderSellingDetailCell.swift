//
//  OrderSellingDetailCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderSellingDetailCell: UITableViewCell {

    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderInfoLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accoundLabel: UILabel!
    @IBOutlet weak var codeButton: UIButton!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var codeLeftLabel: UILabel!
    @IBOutlet weak var codeWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    var cancelBlock : (()->())?
    var payBlock : (()->())?
    var timeOutBlock : (()->())?
    
    var timer : DispatchSourceTimer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
        
        self.cancelLabel.backgroundColor = UIColor.clear
        self.cancelLabel.layer.borderColor = JXOrangeColor.cgColor
        self.cancelLabel.layer.borderWidth = 1
        self.cancelLabel.textColor = JXOrangeColor
        
        //self.cancelLabel.isUserInteractionEnabled = true
        //self.cancelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelTap(tap:))))
        self.payButton.addTarget(self, action: #selector(payTap(tap:)), for: .touchUpInside)
        self.payButton.setTitle("确认已收款", for: .normal)
        
    }
    deinit {
        self.timer?.cancel()
    }
    var entity: OrderDetailEntity? {
        didSet{
            //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
            if entity?.orderStatus == 1 {
                self.orderStatusLabel.text = "待付款"
            } else if entity?.orderStatus == 2 {
                self.orderStatusLabel.text = "待卖家确认"
                self.orderInfoLabel.text = "买家已付款，请确认已收到付款"
            } else if entity?.orderStatus == 3 {
                self.orderStatusLabel.text = "已完成"
            } else {
                self.orderStatusLabel.text = "已关闭"
            }
            self.orderNumberLabel.text = "订单号：\(entity?.orderNum ?? "")"
            
            self.priceLabel.text = "交易单价：\(entity?.coinPrice ?? 0) \(configuration_valueType)"
            self.totalLabel.text = "交易数量：\(entity?.coinCounts ?? 0)\(configuration_coinName)"
            self.valueLabel.text = "\(entity?.payAmount ?? 0)\(configuration_valueType)"
            
            if entity?.payType == 1 {
                self.payNameLabel.text = "支付宝"
            } else if entity?.payType == 2 {
                self.payNameLabel.text = "微信"
            }  else if entity?.payType == 3 {
                self.payNameLabel.text = "银行卡"
                
                self.codeLeftLabel.text = "开户行"
                self.bankNameLabel.text = entity?.bank
                self.codeWidthConstraint.constant = 0.01
                self.codeButton.isHidden = true
            }
            self.userNameLabel.text = entity?.name
            self.accoundLabel.text = entity?.account
            self.remarkLabel.text = "无"
            
            var timeInter = 0
            
            if let type = entity?.orderType, type == "出售" {
                timeInter = entity?.receiveExpireTime ?? 0
            }
            
            if timeInter > 0 {
                self.cancelLabel.isUserInteractionEnabled = true
                
                self.timer = CommonManager.countDown1(timeOut: timeInter, process: { (process) in
                    
                    let str = self.getCountDownFormatStr(timeInterval: process)
                    self.cancelLabel.text = self.getCountDownCustomStr(str: str)
                }) {
                    if let block = self.timeOutBlock {
                        block()
                    }
                }
            }
            
        }
    }
    @objc func cancelTap(tap:UITapGestureRecognizer) {
        if let block = self.cancelBlock {
            block()
        }
    }
    @objc func payTap(tap:UITapGestureRecognizer) {
        if let block = self.payBlock {
            block()
        }
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
