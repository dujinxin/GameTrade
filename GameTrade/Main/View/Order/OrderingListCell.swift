//
//  OrderingListCell.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/27.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class OrderingListCell: UITableViewCell {

    @IBOutlet weak var mainContentView: UIView!{
        didSet{
            mainContentView.backgroundColor = JXViewBgColor
            mainContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
            mainContentView.layer.shadowOpacity = 1
            mainContentView.layer.shadowRadius = 33
            mainContentView.layer.shadowColor = JX22222cShadowColor.cgColor
            mainContentView.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var MerchantNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!{
        didSet{
            buyButton.backgroundColor = JXSeparatorColor
        }
    }
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!{
        didSet{
            buyButton.tag = 1314
            
            
            buyButton.backgroundColor = JXMainColor
            buyButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            buyButton.layer.shadowOpacity = 1
            buyButton.layer.shadowRadius = 10
            buyButton.layer.shadowColor = JX10101aShadowColor.cgColor
            buyButton.layer.cornerRadius = 2
        }
    }
    
    var buyBlock : (()->())?
    
    @IBAction func buy(_ sender: Any) {
        if let block = buyBlock {
            block()
        }
    }
    var entity: OrderEntity? {
        didSet{
            self.MerchantNameLabel.text = entity?.orderType
            self.timeLabel.text = entity?.createTime
            self.numberLabel.text = "数量：\(entity?.coinCounts ?? 0)\(configuration_coinName)"
            self.valueLabel.text = "\(entity?.payAmount ?? 0)\(configuration_valueType)"
            //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
//            if entity?.orderStatus == 1 {
//                self.statusLabel.text = "待付款"
//            } else if entity?.orderStatus == 2 {
//                self.statusLabel.text = "待确认付款"
//            } else {
//                self.statusLabel.text = "待付款"
//            }
            if let type = entity?.orderType, type == "购买" {
                self.MerchantNameLabel.textColor = JXRedColor
                self.buyButton.setTitle("付款倒计时...", for: .normal)
                if entity?.orderStatus == 1 {
                    self.statusLabel.text = "待付款"
                } else if entity?.orderStatus == 2 {
                    self.statusLabel.text = "待卖家确认"
                }
            } else {
                self.MerchantNameLabel.textColor = JXGreenColor
                self.buyButton.setTitle("确认已收款", for: .normal)
                self.statusLabel.text = "待卖家确认"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 
        self.statusLabel.textColor = JXMainColor
        self.numberLabel.textColor = JXMainText50Color
        self.timeLabel.textColor = JXMainText50Color
        self.valueLabel.textColor = JXMainTextColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
