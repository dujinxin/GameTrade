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
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var payNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accoundLabel: UILabel!
    
    @IBOutlet weak var remarkLabel: UILabel!
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var shopLevelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
        
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
    var entity: OrderDetailEntity? {
        didSet{
            //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
            if entity?.orderStatus == 1 {
                self.orderStatusLabel.text = "待付款"
            } else if entity?.orderStatus == 2 {
                self.orderStatusLabel.text = "待确认付款"
            } else if entity?.orderStatus == 3 {
                self.orderStatusLabel.text = "已完成"
                self.orderInfoLabel.text = "您已成功完成本次交易"
            } else {
                self.orderStatusLabel.text = "已关闭"
                self.orderInfoLabel.text = "订单因超时已自动关闭"
            }
            self.orderNumberLabel.text = "订单号：\(entity?.orderNum ?? "")"
            
            
            self.priceLabel.text = "交易单价：\(entity?.coinPrice ?? 0) \(configuration_valueType)"
            self.totalLabel.text = "交易数量：\(entity?.coinCounts ?? 0) \(configuration_coinName)"
            self.valueLabel.text = "\(entity?.payAmount ?? 0)\(configuration_valueType)"
            
            if entity?.payType == 1 {
                self.payNameLabel.text = "支付宝"
            } else if entity?.payType == 2 {
                self.payNameLabel.text = "微信"
            } else {
                self.payNameLabel.text = "银行卡"
            }
            self.userNameLabel.text = entity?.name
            self.accoundLabel.text = entity?.account
            //self.remarkLabel.text = entity.
            
            if
                let str = entity?.agentHeadImg,
                let url = URL(string: str) {
                self.shopImageView.sd_setImage(with: url, completed: nil)
            }
            self.shopNameLabel.text = entity?.agentName
        }
    }
}
