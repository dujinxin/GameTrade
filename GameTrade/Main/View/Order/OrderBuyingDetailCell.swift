//
//  OrderBuyingDetailCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderBuyingDetailCell: UITableViewCell {

    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var tradeView: UIView!{
        didSet{
            tradeView.layer.cornerRadius = 4
            tradeView.backgroundColor = JXOrderDetailBgColor
            
            tradeView.backgroundColor = JXViewBgColor
            tradeView.layer.shadowOffset = CGSize(width: 0, height: 10)
            tradeView.layer.shadowOpacity = 1
            tradeView.layer.shadowRadius = 33
            tradeView.layer.shadowColor = JX22222cShadowColor.cgColor
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var listView: UIView!{
        didSet{
            listView.layer.cornerRadius = 4
            listView.backgroundColor = JXOrderDetailBgColor
            
            listView.backgroundColor = JXViewBgColor
            listView.layer.shadowOffset = CGSize(width: 0, height: 10)
            listView.layer.shadowOpacity = 1
            listView.layer.shadowRadius = 33
            listView.layer.shadowColor = JX22222cShadowColor.cgColor
        }
    }
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accoundLabel: UILabel!
    @IBOutlet weak var codeButton: UIButton!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var codeLeftLabel: UILabel!
    @IBOutlet weak var codeWidthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    
    @IBOutlet weak var payContentView: UIView!{
        didSet{
            payContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(payTap(tap:))))
            //self.payButton.addTarget(self, action: #selector(payTap(tap:)), for: .touchUpInside)
            
            payContentView.backgroundColor = JXMainColor
            payContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
            payContentView.layer.shadowOpacity = 1
            payContentView.layer.shadowRadius = 10
            payContentView.layer.shadowColor = JX10101aShadowColor.cgColor
            payContentView.layer.cornerRadius = 2
        }
    }
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!{
        didSet{
            cancelLabel.backgroundColor = UIColor.clear
            cancelLabel.layer.cornerRadius = 2
            cancelLabel.layer.borderColor = JXMainColor.cgColor
            cancelLabel.layer.borderWidth = 1
            cancelLabel.textColor = JXMainColor
            
            cancelLabel.isUserInteractionEnabled = true
            cancelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelTap(tap:))))
        }
    }
    @IBOutlet weak var payButton: UIButton!
    
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopLabel: UILabel!{
        didSet{
            shopLabel.textColor = JXMerchantIconTextColor
            shopLabel.backgroundColor = JXMerchantIconBgColor
            
            shopLabel.layer.cornerRadius = 20
            shopLabel.layer.masksToBounds = true
            
            if app_style <= 1 {
                
            } else {
                shopLabel.layer.borderColor = JXFfffffColor.cgColor
                shopLabel.layer.borderWidth = 2
            }
        }
    }
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    @IBOutlet weak var line: OrderLineView!{
        didSet{
            if app_style <= 1 {
                line.lineColor = JXMainText50Color
            } else {
                line.lineColor = UIColor.rgbColor(rgbValue: 0x3f415d)
            }
        }
    }
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line5: UIView!
    
    var chatBlock : (()->())?
    var showCodeBlock : (()->())?
    var cancelBlock : (()->())?
    var payBlock : (()->())?
    var timeOutBlock : (()->())?
    var copyBlock : (()->())?
    
    var timer : DispatchSourceTimer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
        
        self.orderStatusLabel.textColor = JXMainTextColor
        self.orderNumberLabel.textColor = JXMainText50Color
        self.orderInfoLabel.textColor = JXMainText50Color
        
        self.priceLabel.textColor = JXMainTextColor
        self.totalLabel.textColor = JXMainTextColor
        self.valueLabel.textColor = JXRedColor
        
        self.payNameLabel.textColor = JXMainTextColor
        self.userNameLabel.textColor = JXMainTextColor
        self.accoundLabel.textColor = JXMainTextColor
        self.bankNameLabel.textColor = JXMainTextColor
        self.remarkLabel.textColor = JXMainTextColor
        
        //self.line.tintColor = JXMainTextColor
        //self.line.image = UIImage(named: "line")?.withRenderingMode(.alwaysTemplate)
        self.line1.backgroundColor = JXSeparatorColor
        self.line2.backgroundColor = JXSeparatorColor
        self.line3.backgroundColor = JXSeparatorColor
        self.line4.backgroundColor = JXSeparatorColor
        self.line5.backgroundColor = JXSeparatorColor
        
        self.chatButton.addTarget(self, action: #selector(chat), for: .touchUpInside)
        
        self.noticeLabel.textColor = JXMainText50Color
        
    }
    
    func cancel() {
        if let timer = self.timer {
            timer.suspend()
            timer.cancel()
        }
    }
    var entity: OrderDetailEntity? {
        didSet{
            //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
            if entity?.orderStatus == 1 {
                self.orderStatusLabel.text = "待付款"
                self.orderInfoLabel.text = "您已成功下单，请尽快付款"
            } else if entity?.orderStatus == 2 {
                self.orderStatusLabel.text = "待卖家确认"
            } else if entity?.orderStatus == 3 {
                self.orderStatusLabel.text = "已完成"
            } else {
                self.orderStatusLabel.text = "已关闭"
            }
            self.orderNumberLabel.text = "订单号：\(entity?.orderNum ?? "")"
            
            self.priceLabel.text = "交易单价：\(entity?.coinPrice ?? 0) \(configuration_valueType)"
            self.totalLabel.text = "交易数量：\(entity?.coinCounts ?? 0) \(configuration_coinName)"
            self.discountLabel.text = "优惠红包：-\(entity?.discount ?? 0) \(configuration_valueType)"
            self.valueLabel.text = "\(entity?.payAmount ?? 0) \(configuration_valueType)"
            
            if entity?.payType == 1 {
                self.payNameLabel.text = "支付宝"
            } else if entity?.payType == 2 {
                self.payNameLabel.text = "微信"
            } else if entity?.payType == 3 {
                self.payNameLabel.text = "银行卡"
                
                self.codeLeftLabel.text = "开户行"
                self.bankNameLabel.text = entity?.bank
                self.codeWidthConstraint.constant = 0.01
                self.codeButton.isHidden = true
            }
            
            
            self.userNameLabel.text = entity?.name
            self.accoundLabel.text = entity?.account
            self.remarkLabel.text = entity?.orderCipher
            
            self.cancelLabel.text = "取消订单"
            
//            if
//                let str = entity?.agentHeadImg,
//                let url = URL(string: str) {
//                self.shopImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImage"), options: [], completed: nil)
//            }
            self.shopLabel.text = String(entity?.agentName?.prefix(1) ?? "")
            self.shopNameLabel.text = entity?.agentName
            
            var timeInter = 0
            
            if let type = entity?.orderType, type == "购买" {
                timeInter = entity?.expireTime ?? 0
            } else {
                //timeInter
            }
            
            if timeInter > 0 {
                self.cancelLabel.isUserInteractionEnabled = true
                
                self.timer = CommonManager.countDown1(timeOut: timeInter, process: { (process) in
                    let str = self.getCountDownFormatStr(timeInterval: process)
//                    self.cancelLabel.text = self.getCountDownCustomStr(str: str)
                    self.payButton.setTitle(self.getCountDownCustomStr(str: str), for: .normal)
                    print("订单详情",process)
                }) {
                    if let block = self.timeOutBlock {
                        block()
                    }
                }
            }
        }
    }
    @objc func chat() {
        if let block = self.chatBlock {
            block()
        }
    }
    @objc func cancelTap(tap:UITapGestureRecognizer) {
        self.cancel()
        if let block = self.cancelBlock {
            block()
        }
    }
    @objc func payTap(tap:UITapGestureRecognizer) {
        self.cancel()
        if let block = self.payBlock {
            block()
        }
    }
    @IBAction func copyAccount(_ sender: Any) {
        if let block = self.copyBlock {
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
        return "剩\(str)"
    }
}
