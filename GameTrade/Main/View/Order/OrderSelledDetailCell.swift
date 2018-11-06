//
//  OrderSelledDetailCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderSelledDetailCell: UITableViewCell {

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
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
                self.orderInfoLabel.text = "您的挂卖单已确认付款并转币"
            } else {
                self.orderStatusLabel.text = "已关闭"
                self.orderInfoLabel.text = "您的挂卖单已关闭"
            }
            self.orderNumberLabel.text = "订单号：\(entity?.orderNum ?? "")"
            
            
            self.priceLabel.text = "交易单价：\(entity?.coinPrice ?? 0) \(configuration_valueType)"
            self.totalLabel.text = "交易数量：\(entity?.coinCounts ?? 0)\(configuration_coinName)"
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
            
            
        }
    }
}
