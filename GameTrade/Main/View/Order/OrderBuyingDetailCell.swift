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
    
    @IBOutlet weak var infoBackImageView: UIImageView!
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
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
    
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    
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
        
        //self.infoBackImageView.image = UIImage(named: "Combined Shape")?.resizableImage(withCapInsets: UIEdgeInsetsMake(80, 20, 20, 20), resizingMode: .stretch)
        
        self.chatButton.addTarget(self, action: #selector(chat), for: .touchUpInside)
        
        self.cancelLabel.backgroundColor = UIColor.clear
        self.cancelLabel.layer.borderColor = JXOrangeColor.cgColor
        self.cancelLabel.layer.borderWidth = 1
        self.cancelLabel.textColor = JXOrangeColor
        
        self.cancelLabel.isUserInteractionEnabled = true
        self.cancelLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelTap(tap:))))
        self.payButton.addTarget(self, action: #selector(payTap(tap:)), for: .touchUpInside)
        
        
        self.shopView.layer.shadowOffset = CGSize(width: 0, height: 13)
        self.shopView.layer.shadowOpacity = 1
        self.shopView.layer.shadowRadius = 52
        self.shopView.layer.shadowColor = JX10101aShadowColor.cgColor
        self.shopView.layer.cornerRadius = 4
        
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x2E2F47).cgColor,UIColor.rgbColor(rgbValue: 0x191A2C).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 48 * 2, height: self.shopView.jxHeight)
        //gradientLayer.cornerRadius = 5
        
        self.shopView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func cancel() {
        if let timer = self.timer {
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
            self.totalLabel.text = "交易数量：\(entity?.coinCounts ?? 0)\(configuration_coinName)"
            self.discountLabel.text = "优惠红包：-\(entity?.discount ?? 0)\(configuration_valueType)"
            self.valueLabel.text = "\(entity?.payAmount ?? 0)\(configuration_valueType)"
            
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
            //self.remarkLabel.text = entity.
            
            if
                let str = entity?.agentHeadImg,
                let url = URL(string: str) {
                self.shopImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImage"), options: [], completed: nil)
            }
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
                    
                    print("----",process)
                    
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
        return "取消订单\n(\(str))"
    }
}
