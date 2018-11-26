//
//  OrderBuyedDetailCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderBuyedDetailCell: UITableViewCell {

    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderInfoLabel: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var tradeView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accoundLabel: UILabel!
    @IBOutlet weak var codeButton: UIButton!
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var codeLeftLabel: UILabel!
    @IBOutlet weak var codeWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    var chatBlock : (()->())?
    var copyBlock : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
        
        self.orderNumberLabel.textColor = JXText50Color
        self.orderInfoLabel.textColor = JXText50Color
        
        self.tradeView.layer.cornerRadius = 4
        self.listView.layer.cornerRadius = 4
        
        self.shopLabel.layer.cornerRadius = 20
        self.shopLabel.layer.masksToBounds = true
        
        self.chatButton.addTarget(self, action: #selector(chat), for: .touchUpInside)
        
        
        self.noticeLabel.textColor = JXText50Color
        
//        self.tradeView.layer.shadowOffset = CGSize(width: 0, height: 10)
//        self.tradeView.layer.shadowOpacity = 1
//        self.tradeView.layer.shadowRadius = 40
//        self.tradeView.layer.shadowColor = JX10101aShadowColor.cgColor
//        self.tradeView.layer.cornerRadius = 4
//
//        self.listView.layer.shadowOffset = CGSize(width: 0, height: 10)
//        self.listView.layer.shadowOpacity = 1
//        self.listView.layer.shadowRadius = 40
//        self.listView.layer.shadowColor = JX10101aShadowColor.cgColor
//        self.listView.layer.cornerRadius = 4
        
        
//        let gradientLayer = CAGradientLayer.init()
//        gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x2E2F47).cgColor,UIColor.rgbColor(rgbValue: 0x191A2C).cgColor]
//        gradientLayer.locations = [0]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 48 * 2, height: self.shopView.jxHeight)
//        //gradientLayer.cornerRadius = 5
//
//        self.shopView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    override func updateConstraints() {
        super.updateConstraints()
    }
    var entity: OrderDetailEntity? {
        didSet{
            //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
            if entity?.orderStatus == 1 {
                self.orderStatusLabel.text = "待付款"
                self.orderInfoLabel.text = "您已下单，请尽快付款"
            } else if entity?.orderStatus == 2 {
                self.orderStatusLabel.text = "待卖家确认"
                self.orderInfoLabel.text = "您已付款，等待卖家确认收款"
            } else if entity?.orderStatus == 3 {
                self.orderStatusLabel.text = "已完成"
                self.orderInfoLabel.text = "您已成功完成本次交易"
                self.chatButton.isHidden = true
            } else {
                //self.chatButton.isHidden = true
                self.orderStatusLabel.text = "已关闭"
                if entity?.orderStatus == 4 {
                    self.orderInfoLabel.text = "本次交易已关闭"
                } else if entity?.orderStatus == 5 {
                    self.orderInfoLabel.text = "卖家未收到付款，交易已强制关闭"
                } else {
                    self.orderInfoLabel.text = "本次交易已关闭"
                }
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
            
//            if
//                let str = entity?.agentHeadImg,
//                let url = URL(string: str) {
//                self.shopImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImage"), options: [], completed: nil)
//            }
            self.shopLabel.text = String(entity?.agentName?.prefix(1) ?? "")
            self.shopNameLabel.text = entity?.agentName
            
        }
    }
    
    @objc func chat() {
        if let block = self.chatBlock {
            block()
        }
    }
    @IBAction func copyAccount(_ sender: Any) {
        if let block = self.copyBlock {
            block()
        }
    }
    
}
