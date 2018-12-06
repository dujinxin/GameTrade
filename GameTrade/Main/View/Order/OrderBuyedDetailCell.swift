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
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var codeLeftLabel: UILabel!
    @IBOutlet weak var codeWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    @IBOutlet weak var line: OrderLineView!{
        didSet{
            line.lineColor = JXMainTextColor
        }
    }
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    @IBOutlet weak var line5: UIView!
    
    var chatBlock : (()->())?
    var copyBlock : (()->())?
    
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
        
        //self.line.tintColor = JXMainTextColor
        //self.line.image = UIImage(named: "line")?.withRenderingMode(.alwaysTemplate)
        self.line1.backgroundColor = JXSeparatorColor
        self.line2.backgroundColor = JXSeparatorColor
        self.line3.backgroundColor = JXSeparatorColor
        self.line4.backgroundColor = JXSeparatorColor
        self.line5.backgroundColor = JXSeparatorColor
        
        self.shopLabel.layer.cornerRadius = 20
        self.shopLabel.layer.masksToBounds = true
        
        self.chatButton.addTarget(self, action: #selector(chat), for: .touchUpInside)
        
        
        self.noticeLabel.textColor = JXMainText50Color
        
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
